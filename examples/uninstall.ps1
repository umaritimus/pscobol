puppet apply `
    --modulepath 'C:\ProgramData\PuppetLabs\code\environments\production\modules' `
    --debug `
    --trace `
    --verbose `
    -e "class { 'pscobol' : ensure => 'absent', installdir => 'd:/cobol' , package => '//share/vcbt_40.exe',}"
