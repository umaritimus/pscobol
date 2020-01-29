# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include pscobol::microfocus::update
class pscobol::microfocus::update (
  Enum['present','absent'] $ensure = 'absent',
  String[1] $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL Build Tools',
  String[1] $source = '//share/visualcobol/vcbt_40_pu04_196223.exe',
) {
  debug ("Ensure 'pscobol::microfocus::update' to be '${ensure}' using '${source}' on '${installdir}'")
}
