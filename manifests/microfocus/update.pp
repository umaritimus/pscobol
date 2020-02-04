# @summary
#   Private class to install a set of patches for Micro Focus Visual Cobol
#
# @example
#   include pscobol::microfocus::update
class pscobol::microfocus::update (
  $ensure       = undef,
  $installdir   = undef,
  $patches      = undef,
) {

  debug ("Ensure 'pscobol::microfocus::update' to be '${ensure}' using '${patches}' on '${installdir}'")

  if ($facts['operatingsystem'] == 'windows') {

    if (!empty($patches) and ($ensure == 'present')) {

      $patches.each | String $patch | {
        exec { "Verify ${patch}" :
          command   => Sensitive(@("EOT")),
              Try {
                If (Test-Path -Path ${regsubst("\'${patch}\'", '(/|\\\\)', '\\', 'G')}) {
                  Exit 0
                }
                Exit 1
              } Catch {
                Exit 1
              }
              |-EOT
          provider  => powershell,
          logoutput => true,
          onlyif    => "If ('${patch}' -ne '') { Exit 0 } Else { Exit 1 }"
        }

        debug ("Updating 'Microfocus Micro Focus Visual COBOL' using '${patch}''")

        exec { "Install patch ${patch}" :
          command   => Sensitive("
            ${file('pscobol/pscobol.psm1')}
            Install-MicroFocusVisualCobol `
              -Source ${regsubst("\'${patch}\'", '(/|\\\\)', '\\', 'G')} `
              -InstallDir ${regsubst("\'${installdir}\'", '(/|\\\\)', '\\', 'G')}
          "),
          provider  => powershell,
          logoutput => true,
          require   => Exec["Verify ${patch}"],
          onlyif    => Sensitive(@("EOT")),
            Try {
              If ('${patch}' -ne '') {
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
      debug ("No-Op 'Microfocus Micro Focus Visual COBOL' using '${patches}'")
    }

  } else {
    fail("Unsupported Platform - ${$facts['operatingsystem']}")
  }
}
