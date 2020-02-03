# Execute Module as part of PeopleSoft DPK

## Add module to module list

```powershell
puppet module install puppetlabs-powershell --modulepath ${PuppetCodedir}\production\modules --force
puppet module install puppetlabs-pwshlib --modulepath ${PuppetCodedir}\production\modules --force
puppet module install umaritimus-pscobol --modulepath ${PuppetCodedir}\production\modules --force
```

## Reference module in `pt_role`

Pick the desired target role, e.g. `modules\pt_role\manifests\pt_tools_midtier.pp`

Add module references to appropriate places, e.g.

```ruby
...
  contain ::pt_profile::pt_samba
  contain ::pt_profile::pt_source_details
+ contain ::pscobol
...
```

and

```ruby
...
    Class['::pt_profile::pt_pia'] ->
    Class['::pt_profile::pt_samba'] ->
+   Class['::pscobol'] ->
    Class['::pt_profile::pt_password'] ->
...
```

## Add parameters into hiera

e.g. in `data\psft_customizations.yaml`:

```yaml
---
...
pscobol::ensure: 'present'
pscobol::installdir: 'd:/cobol'
pscobol::package: '//share/vcbt_40.exe'
pscobol::patches: ['//share/vcbt_40_pu04_196223.exe']
pscobol::license: '//share/PS-VC-WIN-VSTUDIO.mflic'
pscobol::ps_home: "%{lookup('ps_home_location')}"
pscobol::ps_app_home: "%{lookup('ps_apphome_location')}"
pscobol::ps_cust_home: "%{lookup('ps_custhome_location')}"
pscobol::targets: ['PS_HOME']
...
```

> Note: This will install `Micro Focus Visual Cobol Build Tools` and compile PeopleSoft cobol in `PS_HOME`

## Execute puppet apply

```powershell
puppet apply "site.pp"
```

## Examine Logs

Watch for output similar to

```log
...
Notice: /Stage[main]/Pscobol::Microfocus::Install/Exec[Verify Installation source]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Microfocus::Install/Exec[Verify Installation source]/returns: executed successfully
Notice: /Stage[main]/Pscobol::Microfocus::Update/Exec[Verify //share/vcbt_40_pu04_196223.exe]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Microfocus::Update/Exec[Verify //share/vcbt_40_pu04_196223.exe]/returns: executed successfully
Notice: /Stage[main]/Pscobol::Microfocus::Update/Exec[Install patch //share/vcbt_40_pu04_196223.exe]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Microfocus::Update/Exec[Install patch //share/vcbt_40_pu04_196223.exe]/returns: executed successfully
Notice: /Stage[main]/Pscobol::Microfocus::License/Exec[Verify License source]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Microfocus::License/Exec[Verify License source]/returns: executed successfully
Notice: /Stage[main]/Pscobol::Microfocus::License/Exec[License Micro Focus Visual COBOL]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Microfocus::License/Exec[License Micro Focus Visual COBOL]/returns: executed successfully
Notice: /Stage[main]/Pscobol::Peoplesoft::Compile/Exec[Compile PS_HOME cobol]/returns: [output redacted]
Notice: /Stage[main]/Pscobol::Peoplesoft::Compile/Exec[Compile PS_HOME cobol]/returns: executed successfully
Notice: Applying pt_profile::pt_password
...
```
