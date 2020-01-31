# @summary
#   Private class to register the Micro Focus Visual Cobol license
#
# @example
#   include pscobol::microfocus::license
class pscobol::microfocus::license (
  $ensure    = undef,
  $license   = undef,
  $lmpath    = undef,
) {

  debug ("Ensure 'pscobol::microfocus::license' to be '${ensure}' using '${license}'")

  if ($facts['operatingsystem'] == 'windows') {

    exec { 'Verify License source' :
      command   => Sensitive(@("EOT")),
          Try {
            If ( Test-Path -Path ${regsubst("\'${license}\'", '(/|\\\\)', '\\', 'G')} ) {
              Exit 0
            }
            Exit 1
          } Catch {
            Exit 1
          }
          |-EOT
      provider  => powershell,
      logoutput => true,
      onlyif    => "If ('${license}' -ne '') { Exit 0 } Else { Exit 1 }"
    }

    if ($ensure == 'present') {

      exec { 'License Micro Focus Visual COBOL' :
        command   => Sensitive("
          ${file('pscobol/pscobol.psm1')}
          Set-MicroFocusVisualCobolLicense `
            -Source ${regsubst("\'${license}\'", '(/|\\\\)', '\\', 'G')} `
            -CesAdminToolPath ${regsubst("\'${lmpath}\'", '(/|\\\\)', '\\', 'G')}
        "),
        provider  => powershell,
        logoutput => true,
        require   => Exec['Verify License source'],
        onlyif    => Sensitive(@("EOT")),
          Try {
            If ('${license}' -ne '') {
              If ( Test-Path -Path ${regsubst("\'${lmpath}\'", '(/|\\\\)', '\\', 'G')} ) {
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
      exec { 'Remove Sentinel RMS License Manager' :
        command   => Sensitive('cmd /c "MsiExec.exe/X{A6C99F57-4EAE-4A25-898D-EFD9AF3DA23D} /quiet"'),
        provider  => powershell,
        logoutput => true,
        onlyif    => Sensitive(@("EOT")),
          Try {
            If ( Test-Path -Path ${regsubst("\'${lmpath}\'", '(/|\\\\)', '\\', 'G')} ) {
              Exit 0
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
