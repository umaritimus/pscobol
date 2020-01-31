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
# @param ensure
#   Standard puppet ensure, e.g. present, absent, installed, etc
#
# @param package
#   Location of the Micro Focus installer file
#
# @param patches
#   Array of locations of patches for Micro Focus Visual Cobol
#
# @param license
#   Micro Focus mflic license file location
#
# @param targets
#   Array of Names of Targets to compile, could be none or few of
#   ('PS_HOME'|'PS_APP_HOME'|'PS_CUST_HOME')
#
# @example
#   include pscobol
class pscobol (
  Enum['present','absent']                                        $ensure     = $pscobol::params::ensure,
  Optional[String[1]]                                             $installdir = $pscobol::params::installdir,
  Optional[String[1]]                                             $package    = $pscobol::params::package,
  Optional[Array[String[1]]]                                      $patches    = $pscobol::params::patches,
  Optional[String[1]]                                             $license    = $pscobol::params::license,
  Optional[Array[Enum['PS_HOME','PS_APP_HOME','PS_CUST_HOME']]]   $targets    = $pscobol::params::targets,
) inherits pscobol::params {

  class { 'pscobol::microfocus':
    ensure     => $ensure,
    installdir => $installdir,
    package    => $package,
    patches    => $patches,
    license    => $license,
  }

  contain 'pscobol::microfocus'
  #contain 'pscobol::peoplesoft'

  #Class['pscobol::microfocus']
  #-> Class['pscobol::peoplesoft']

  #if $targets {
  #  $targets.each | String $target | {
  #    warning ("Got a target - ${target}")
  #  }
  #}
}
