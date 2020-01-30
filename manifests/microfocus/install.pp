# @summary Installs Micro Focus Visual Cobol
#   Installs Micro Focus Visual Cobol
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
#   include pscobol::microfocus::install
class pscobol::microfocus::install  (
  Enum['present','absent'] $ensure = 'absent',
  String $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL',
  String $source = '//share/visualcobol/vcbt_40.exe',
) {
  debug ("Ensure 'pscobol::microfocus::install' to be '${ensure}' using '${source}' on '${installdir}'")

  exec { 'Verify Installation source' :
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
  }

  if ($ensure == 'present') {
    debug ("Installing 'Microfocus Micro Focus Visual COBOL' using ${source}")

    exec { 'Install Microfocus Micro Focus Visual COBOL' :
      command   => Sensitive("
        ${file('pscobol/pscobol.psm1')}
        Install-MicroFocusVisualCobol `
          -Source ${regsubst($source, '(/|\\\\)', '\\', 'G')} `
          -InstallDir ${regsubst($installdir, '(/|\\\\)', '\\', 'G')}
      "),
      provider  => powershell,
      logoutput => true,
      creates   => [
        "${installdir}/bin/cobol.exe",
        'c:/Program Files (x86)/Common Files/SafeNet Sentinel/Sentinel RMS License Manager/WinNT/SentinelCesAdminTool.exe'
      ],
    }
  } else {
    debug ("Removing 'Microfocus Micro Focus Visual COBOL' using ${source}")

    exec { 'Remove Microfocus Micro Focus Visual COBOL' :
      command   => Sensitive("
        ${file('pscobol/pscobol.psm1')}
        Uninstall-MicroFocusVisualCobol `
          -Source ${regsubst($source, '(/|\\\\)', '\\', 'G')} `
          -InstallDir ${regsubst($installdir, '(/|\\\\)', '\\', 'G')}
      "),
      provider  => powershell,
      logoutput => true,
      onlyif    => Sensitive(@("EOT")),
        Try {
          If (Test-Path -Path ${regsubst("${installdir}/bin/cobol.exe", '(/|\\\\)', '\\', 'G')}) {
            Exit 0
          }
          Exit 1
        } Catch {
          Exit 1
        }
        |-EOT
    }

    exec { 'Remove Sentinel RMS License Manager' :
      command   => 'cmd /c "MsiExec.exe/X{A6C99F57-4EAE-4A25-898D-EFD9AF3DA23D} /quiet"',
      provider  => powershell,
      logoutput => true,
      onlyif    => Sensitive(@("EOT")),
        Try {
          If (Test-Path -Path ${regsubst('C:/Program Files (x86)/Common Files/SafeNet Sentinel/Sentinel RMS License Manager/WinNT/SentinelCesAdminTool.exe', '(/|\\\\)', '\\', 'G')}) {
            Exit 0
          }
          Exit 1
        } Catch {
          Exit 1
        }
        |-EOT
      require   => Exec['Remove Microfocus Micro Focus Visual COBOL'],
    }
  }
}
