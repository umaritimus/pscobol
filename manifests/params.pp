# @summary
#   Private class for Micro Focus Visual Cobol module
#   that defines default parameters
#
# @example
#   include pscobol::params
class pscobol::params {
  $ensure         = 'present'
  $ps_home        =  undef
  $ps_app_home    =  undef
  $ps_cust_home   =  undef

  case $facts['os']['family'] {
    'windows': {
      $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL'
      $lmpath     = 'C:/Program Files (x86)/Common Files/SafeNet Sentinel/Sentinel RMS License Manager/WinNT/CesAdminTool.exe'
      $package    =  undef
      $patches    =  undef
      $license    =  undef
      $targets    =  undef
    }
    default: {
      $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL'
      $lmpath     = 'C:/Program Files (x86)/Common Files/SafeNet Sentinel/Sentinel RMS License Manager/WinNT/CesAdminTool.exe'
      $package    =  undef
      $patches    =  undef
      $license    =  undef
      $targets    =  undef
    }
  }
}
