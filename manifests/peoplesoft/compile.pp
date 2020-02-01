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

  if ($facts['operatingsystem'] == 'windows') {
    if ($targets and ($ensure == 'present')) {
      $targets.each | String $target | {

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
