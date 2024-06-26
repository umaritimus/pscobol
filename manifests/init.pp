# @summary Base pscobol class
#
#   Base pscobol class
#
#
# @param ensure
#   Standard puppet ensure, Only 'present' and 'absent', are allowed
#
# @param installdir
#   Micro Focus installation location, also COBDIR
#
# @param package
#   Location of the Micro Focus installer file
#
# @param patches
#   Array of locations of patches for Micro Focus Visual Cobol
#
# @param lmpath
#   Location of the Micro Focus License Manager
#
# @param license
#   Micro Focus mflic license file location
#
# @param ps_home
#   Location of Peoplesoft PS_HOME directory
#
# @param ps_app_home
#   Location of Peoplesoft PS_HOME directory
#
# @param ps_cust_home
#   Location of Peoplesoft PS_HOME directory
#
# @param targets
#   Array of Names of Targets to compile, could be none or few of
#   ('PS_HOME'|'PS_APP_HOME'|'PS_CUST_HOME')
#
# @example
#   include pscobol
class pscobol (
  Enum['present','absent']                                        $ensure       = $pscobol::params::ensure,
  Optional[String[1]]                                             $installdir   = $pscobol::params::installdir,
  Optional[String[1]]                                             $package      = $pscobol::params::package,
  Optional[Array[String[1]]]                                      $patches      = $pscobol::params::patches,
  Optional[String[1]]                                             $lmpath       = $pscobol::params::lmpath,
  Optional[String[1]]                                             $license      = $pscobol::params::license,
  Optional[String[1]]                                             $ps_home      = $pscobol::params::ps_home,
  Optional[String[1]]                                             $ps_app_home  = $pscobol::params::ps_app_home,
  Optional[String[1]]                                             $ps_cust_home = $pscobol::params::ps_cust_home,
  Optional[Array[Enum['PS_HOME','PS_APP_HOME','PS_CUST_HOME']]]   $targets      = $pscobol::params::targets,
) inherits pscobol::params {
  class { 'pscobol::microfocus':
    ensure     => $ensure,
    installdir => $installdir,
    package    => $package,
    patches    => $patches,
    lmpath     => $lmpath,
    license    => $license,
  }

  class { 'pscobol::peoplesoft':
    ensure       => $ensure,
    installdir   => $installdir,
    ps_home      => $ps_home,
    ps_app_home  => $ps_app_home,
    ps_cust_home => $ps_cust_home,
    targets      => $targets,
  }

  contain 'pscobol::microfocus'
  contain 'pscobol::peoplesoft'

  Class['pscobol::microfocus']
  -> Class['pscobol::peoplesoft']
}
