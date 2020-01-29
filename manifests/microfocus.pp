# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include pscobol::microfocus
class pscobol::microfocus  (
  Enum['present','absent'] $ensure = 'absent',
  String[1] $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL Build Tools',
  String[1] $installsource = '//share/visualcobol/vcbt_40.exe',
  String[1] $patchsource = '//share/visualcobol/vcbt_40_pu04_196223.exe',
) {
  debug ("Ensure 'pscobol::microfocus' to be '${ensure}' in '${installdir}'")

  if ($facts['operatingsystem'] == 'windows') {

    class { 'pscobol::microfocus::install':
      ensure     => $ensure,
      installdir => $installdir,
      source     => $installsource,
    }

    class { 'pscobol::microfocus::update':
      ensure     => $ensure,
      installdir => $installdir,
      source     => $patchsource,
      require    => Class['pscobol::microfocus::install'],
    }

    contain 'pscobol::microfocus::install'
    contain 'pscobol::microfocus::update'

  } else {
    warning ('Only Windows OS is supported at this point. Please PR!')
  }
}
