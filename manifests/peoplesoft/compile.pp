# @summary
#   Private class for Peoplesoft cobol compile
#
# @example
#   include pscobol::peoplesoft::compile
class pscobol::peoplesoft::compile (
  $ensure            =  undef,
  $installdir        =  undef,
  $ps_home           =  undef,
  $ps_app_home       =  undef,
  $ps_cust_home      =  undef,
  $targets           =  undef,
) {

  debug ("Ensure 'pscobol::peoplesoft::compile' to be '${ensure}' using '${installdir}' on '${targets}'")

  if ($facts['operatingsystem'] == 'windows') {
    if (!empty($targets) and ($ensure == 'present')) {

      exec { 'Verify PS_HOME/setup Path' :
        command   => Sensitive(@("EOT")),
          If ('${ps_home}' -ne '') {
            If (-not (Test-Path -Path ${regsubst("\'${ps_home}/setup\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop)) {
              Throw "Path for ${regsubst("\'${ps_home}/setup\'", '(/|\\\\)', '\\', 'G')} is invalid"
            }
          } Else {
            If (-not (Test-Path -Path "$([System.Environment]::GetEnvironmentVariable('PS_HOME'))\\setup")) {
              Throw "Path for '$([System.Environment]::GetEnvironmentVariable('PS_HOME'))/setup' is invalid"
            }
          }
          |- EOT
        provider  => powershell,
        logoutput => true,
      }

      exec { 'Verify COBDIR/bin/cobol.exe Path' :
        command   => Sensitive(@("EOT")),
          If ('${installdir}' -ne '') {
            If (-not (Test-Path -Path ${regsubst("\'${installdir}/bin/cobol.exe\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop)) {
              Throw "Path for ${regsubst("\'${installdir}/bin/cobol.exe\'", '(/|\\\\)', '\\', 'G')} is invalid"
            }
          } Else {
            If (-not ([System.Environment]::GetEnvironmentVariable('COBDIR'))) {
              Throw "Environment Variable 'COBDIR' is not defined"
            }
            If (-not (Test-Path -Path "$([System.Environment]::GetEnvironmentVariable('COBDIR'))\\bin\\cobol.exe")) {
              Throw "Path for 'COBDIR/bin/cobol.exe' is invalid"
            }
          }
          |- EOT
        provider  => powershell,
        logoutput => true,
      }

      $targets.each | String $target | {

        debug ("Compiling '${target}' cobol using '${installdir}'")

        exec { "Verify ${target} Environment Variable" :
          command   => Sensitive(@("EOT")),
            If (-not ([System.Environment]::GetEnvironmentVariable('${target}'))) {
              Throw 'The Environment variable ${target} must be declared'
            }
            |- EOT
          provider  => powershell,
          logoutput => true,
          require   => Exec['Verify PS_HOME/setup Path'],
          onlyif    => Sensitive(@("EOT")),
            If (('${target}' -eq 'PS_APP_HOME') -and ('${ps_app_home}' -eq '')) {
              Exit 0
            } ElseIf (('${target}' -eq 'PS_CUST_HOME') -and ('${ps_cust_home}' -eq '')) {
              Exit 0
            } ElseIf (('${target}' -eq 'PS_HOME') -and ('${ps_home}' -eq '')) {
              Exit 0
            }
            Exit 1
            |- EOT
        }

        exec { "Verify ${target}/src/cbl Path" :
          command   => Sensitive(@("EOT")),
            If ('${target}' -eq 'PS_APP_HOME') {
              If ('${ps_app_home}' -ne '') {
                If (-not (Test-Path -Path ${regsubst("\'${ps_app_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop)) {
                  Throw "Path for ${regsubst("\'${ps_app_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} is invalid"
                }
              } Else {
                If (-not (Test-Path -Path "$([System.Environment]::GetEnvironmentVariable('PS_APP_HOME'))\\src\\cbl")) {
                  Throw "Path for '$([System.Environment]::GetEnvironmentVariable('PS_APP_HOME'))/src/cbl' is invalid"
                }
              }
            } ElseIf ('${target}' -eq 'PS_CUST_HOME') {
              If ('${ps_cust_home}' -ne '') {
                If (-not (Test-Path -Path ${regsubst("\'${ps_cust_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop)) {
                  Throw "Path for ${regsubst("\'${ps_cust_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} is invalid"
                }
              } Else {
                If (-not (Test-Path -Path "$([System.Environment]::GetEnvironmentVariable('PS_CUST_HOME'))\\src\\cbl")) {
                  Throw "Path for '$([System.Environment]::GetEnvironmentVariable('PS_CUST_HOME'))/src/cbl' is invalid"
                }
              }
            } ElseIf ('${target}' -eq 'PS_HOME') {
              If ('${ps_home}' -ne '') {
                If (-not (Test-Path -Path ${regsubst("\'${ps_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop)) {
                  Throw "Path for ${regsubst("\'${ps_home}/src/cbl\'", '(/|\\\\)', '\\', 'G')} is invalid"
                }
              } Else {
                If (-not (Test-Path -Path "$([System.Environment]::GetEnvironmentVariable('PS_HOME'))\\src\\cbl")) {
                  Throw "Path for '$([System.Environment]::GetEnvironmentVariable('PS_HOME'))/src/cbl' is invalid"
                }
              }
            }
            |- EOT
          provider  => powershell,
          logoutput => true,
          require   => Exec['Verify PS_HOME/setup Path', "Verify ${target} Environment Variable"],
        }

        exec { "Compile ${target} cobol" :
          command   => Sensitive("
            ${file('pscobol/pscobol.psm1')}
            Invoke-CobolCompile `
              -ps_home ${regsubst("\'${ps_home}\'", '(/|\\\\)', '\\', 'G')} `
              -ps_app_home ${regsubst("\'${ps_app_home}\'", '(/|\\\\)', '\\', 'G')} `
              -ps_cust_home ${regsubst("\'${ps_cust_home}\'", '(/|\\\\)', '\\', 'G')} `
              -cobroot ${regsubst("\'${installdir}\'", '(/|\\\\)', '\\', 'G')} `
              -Target ${target}
          "),
          provider  => powershell,
          logoutput => true,
          require   => Exec['Verify PS_HOME/setup Path', 'Verify COBDIR/bin/cobol.exe Path', "Verify ${target}/src/cbl Path"],
          onlyif    => Sensitive(@("EOT")),
            Try {
              If ('${target}' -ne '') {
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
    }

  } else {
    fail("Unsupported Platform - ${$facts['operatingsystem']}")
  }
}
