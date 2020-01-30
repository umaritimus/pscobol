# @summary Installs a patch for Micro Focus Visual Cobol
#   Installs a cumulative patch for Micro Focus Visual Cobol
#
# @param ensure
#   Standard puppet ensure, e.g. present, absent, installed, etc
#
# @param installdir
#   Location where Microfocus Visual Cobol is installed
#
# @param source
#   Build Tools installer location
#
# @example
#   include pscobol::microfocus::update
class pscobol::microfocus::update (
  Enum['present','absent'] $ensure = 'absent',
  String $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL',
  String $source = '',
) {
  debug ("Ensure 'pscobol::microfocus::update' to be '${ensure}' using '${source}' on '${installdir}'")

  exec { 'Verify Update source' :
    command   => Sensitive(@("EOT")),
        Try {
          If (Test-Path -Path ${regsubst($source, '(/|\\\\)', '\\', 'G')}) {
            Exit 0
          }
          Exit 1
        } Catch {
          Exit 1
        }
        |-EOT
    provider  => powershell,
    logoutput => true,
    onlyif    => "If ('${source}' -ne '') { Exit 0 } Else { Exit 1 }"
  }

  if ($ensure == 'present') {
    debug ("Updating 'Microfocus Micro Focus Visual COBOL' using ${source}")

    exec { 'Update Microfocus Micro Focus Visual COBOL' :
      command   => Sensitive("
        ${file('pscobol/pscobol.psm1')}
        Install-MicroFocusVisualCobol `
          -Source ${regsubst($source, '(/|\\\\)', '\\', 'G')} `
          -InstallDir ${regsubst($installdir, '(/|\\\\)', '\\', 'G')}
      "),
      provider  => powershell,
      logoutput => true,
      onlyif   => Sensitive(@("EOT")),
        Try {
          If ('${source}' -ne '') {
            If (Test-Path -Path ${regsubst("${installdir}/bin/cobol.exe", '(/|\\\\)', '\\', 'G')}) {
              Exit 0
            } 
          }
          Exit 1
        } Catch {
          Exit 1
        }
        |-EOT
    }
  } else {
    debug ("No-Op 'Microfocus Micro Focus Visual COBOL' using ${source}")
  }
}
