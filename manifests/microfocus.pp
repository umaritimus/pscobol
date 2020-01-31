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
  Enum['present','absent']        $ensure            = $pscobol::params::ensure,
  Optional[String]                $installdir        = $pscobol::params::installdir,
  Optional[String]                $package           = $pscobol::params::package,
  Optional[Array[String[1]]]      $patches           = $pscobol::params::patches,
  Optional[String]                $license           = $pscobol::params::license,
) inherits pscobol::params {

  debug ("Ensure 'pscobol::microfocus' to be '${ensure}' in '${installdir}'")

  $lmpath = $pscobol::params::lmpath

  class { 'pscobol::microfocus::install':
    ensure     => $ensure,
    installdir => $installdir,
    package    => $package,
  }

  class { 'pscobol::microfocus::update':
    ensure     => $ensure,
    installdir => $installdir,
    patches    => $patches,
  }

  class { 'pscobol::microfocus::license':
    ensure  => $ensure,
    license => $license,
    lmpath  => $lmpath,
  }

  contain 'pscobol::microfocus::install'
  contain 'pscobol::microfocus::update'
  contain 'pscobol::microfocus::license'

  if ($ensure == 'present') {
    Class['pscobol::microfocus::install'] -> Class['pscobol::microfocus::update'] -> Class['pscobol::microfocus::license']
  } else {
    Class['pscobol::microfocus::license'] -> Class['pscobol::microfocus::install']
  }

}
