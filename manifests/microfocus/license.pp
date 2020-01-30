# @summary Registers the Micro Focus Visual Cobol license
#   Registers the Micro Focus Visual Cobol license
#
# @param ensure
#   Standard puppet ensure, e.g. present, absent, installed, etc
#
# @param source
#   Micro Focus mflic license file location
#
# @example
#   include pscobol::microfocus::license
class pscobol::microfocus::license (
  Enum['present','absent'] $ensure = 'absent',
  String $source = '//share/visualcobol/PS-VC-WIN-VSTUDIO.mflic',
){
  debug ("Ensure 'pscobol::microfocus::license' to be '${ensure}' using '${source}'")

  if ($facts['operatingsystem'] == 'windows') {

    exec { 'Verify License source' :
      command   => Sensitive(@("EOT")),
          Try {
            If ( Test-Path -Path ${regsubst("\'${source}\'", '(/|\\\\)', '\\', 'G')} ) {
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

      $lmpath = 'C:/Program Files (x86)/Common Files/SafeNet Sentinel/Sentinel RMS License Manager/WinNT/CesAdminTool.exe'

      exec { 'License Micro Focus Visual COBOL' :
        command   => Sensitive("
          ${file('pscobol/pscobol.psm1')}
          Set-MicroFocusVisualCobolLicense `
            -Source ${regsubst("\'${source}\'", '(/|\\\\)', '\\', 'G')} `
            -CesAdminToolPath ${regsubst("\'${lmpath}\'", '(/|\\\\)', '\\', 'G')}
        "),
        provider  => powershell,
        logoutput => true,
        require   => Exec['Verify License source'],
        onlyif    => Sensitive(@("EOT")),
          Try {
            If ('${source}' -ne '') {
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
      debug ("No-Op 'Microfocus Micro Focus Visual COBOL' using '${source}'")
    }

  } else {
    warning ('Only Windows OS is supported at this point. Please PR!')
  }
}
