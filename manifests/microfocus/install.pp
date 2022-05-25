# @summary
#   Private class for Micro Focus Visual Cobol installation
#
# @example
#   include pscobol::microfocus::install
class pscobol::microfocus::install (
  $ensure       = undef,
  $installdir   = undef,
  $package      = undef,
) {

  debug ("Ensure 'pscobol::microfocus::install' to be '${ensure}' using '${package}' on '${installdir}'")

  if ($facts['operatingsystem'] == 'windows') {

    exec { 'Verify Installation source' :
      command   => Sensitive(@("EOT")),
          Try {
            If ( Test-Path -Path ${regsubst("\'${package}\'", '(/|\\\\)', '\\', 'G')} ) {
              Exit 0
            }
            Exit 1
          } Catch {
            Exit 1
          }
          |-EOT
      provider  => powershell,
      logoutput => true,
      onlyif    => "If ('${package}' -ne '') { Exit 0 } Else { Exit 1 }"
    }

    if ($ensure == 'present') {
      debug ("Installing 'Microfocus Micro Focus Visual COBOL' using '${package}'")

      exec { 'Install Microfocus Micro Focus Visual COBOL' :
        command   => Sensitive("
          ${file('pscobol/pscobol.psm1')}
          Install-MicroFocusVisualCobol `
            -Source ${regsubst("\'${package}\'", '(/|\\\\)', '\\', 'G')} `
            -InstallDir ${regsubst("\'${installdir}\'", '(/|\\\\)', '\\', 'G')}
        "),
        provider  => powershell,
        logoutput => true,
        timeout   => 1200,
        require   => Exec['Verify Installation source'],
        creates   => ["${installdir}/bin/cobol.exe"],
        onlyif    => "If ('${package}' -ne '') { Exit 0 } Else { Exit 1 }"
      }
    } else {
      debug ("Removing 'Microfocus Micro Focus Visual COBOL' using '${package}'")

      exec { 'Remove Microfocus Micro Focus Visual COBOL' :
        command   => Sensitive("
          ${file('pscobol/pscobol.psm1')}
          Uninstall-MicroFocusVisualCobol `
            -Source ${regsubst("\'${package}\'", '(/|\\\\)', '\\', 'G')} `
            -InstallDir ${regsubst("\'${installdir}\'", '(/|\\\\)', '\\', 'G')}
        "),
        provider  => powershell,
        logoutput => true,
        timeout   => 1200,
        require   => Exec['Verify Installation source'],
        onlyif    => Sensitive(@("EOT")),
          Try {
            If ('${package}' -ne '') {
              If (Test-Path -Path ${regsubst("\'${installdir}/bin/cobol.exe\'", '(/|\\\\)', '\\', 'G')}) {
                Exit 0
              }
            }
            Exit 1
          } Catch {
            Exit 1
          }
          |-EOT
      }
    }

  } else {
    fail("Unsupported Platform - ${$facts['operatingsystem']}")
  }
}
