# @summary Administers Micro Focus Visual Cobol resource
#   Administers Micro Focus Visual Cobol resource
#
# @param ensure
#   Standard puppet ensure, e.g. present, absent, installed, etc
#
# @param installdir
#   Location where Microfocus Visual Cobol is installed
#
# @param installsource
#   Build Tools installer location
#
# @param patchsource
#   Build Tools Patch installer location
#
# @example
#   include pscobol::microfocus
class pscobol::microfocus  (
  Enum['present','absent'] $ensure = 'absent',
  String $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL',
  String $installsource = '//share/visualcobol/vcbt_40.exe',
  String $patchsource = '',
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
