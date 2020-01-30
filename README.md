# pscobol

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with pscobol](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pscobol](#beginning-with-pscobol)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [Changelog](#changelog)

## Description

This module adds resources capable of administering Micro Focus Visual Cobol installation, including installation and removal of
Micro Focus Visual Cobol, installation of patches and registration of licenses.

## Setup

### Setup Requirements **OPTIONAL**

To use `pscobol` module on windows, powershell provider is required, as much of the code is written in powershell.  Depending on the version of your Windows operating system, you may be required to download and install, the following modules from the forge:

* "puppetlabs/powershell"
* "puppetlabs/pwshlib"

### Beginning with pscobol

To start using the module, simply install the to your modulepath, e.g.

```powershell
puppet module install puppetlabs-powershell --modulepath <your module path>
puppet module install puppetlabs-pwshlib    --modulepath <your module path>
puppet module install umaritimus-pscobol    --modulepath <your module path>
```

## Usage

Here's a complete example of installing Micro Focus Visual Cobol Built Tools, updating it with the patch and registering the license.

We have the installer, patch and license file download to a `\\share\visualcobol` directory on windows.  We would like to install `Micro Focus Visual Cobol Built Tools` into `d:\cobol` location.

We can register all these parameters in our hiera by adding these values into a yaml file within the data hierarchy:

```yaml
---
pscobol::microfocus::ensure: 'present'
pscobol::microfocus::installdir: 'd:/cobol'
pscobol::microfocus::installsource: '//share/visualcobol/vcbt_40.exe'
pscobol::microfocus::patchsource: '//share/visualcobol/vcbt_40_pu04_196223.exe'
pscobol::microfocus::licensesource: '//share/visualcobol/PS-VC-WIN-VSTUDIO.mflic'
```

> **Note:**
> * The paths are strings, written in the Unix path format.
> * Parameters `ensure` and `installsource` are required.
> * If `patchsource` is not specified, no patches will be applied.
> * If `licensesource` is not specified, no licenses will be registered in the license manager.
> * If `installdir` is not specified, the installation target will default to the `Program Files` location,e.g. `'C:\Program Files (x86)\Micro Focus\Visual COBOL'`


To uninstall Micro Focus Visual Cobol, simply replace the ensure value of `'present'` by `'absent'`

## Limitations

* Module `pscobol` was only tested for deployment of `Micro Focus Visual Cobol Built Tools`, but should work for others...
* It is known to work on `Microsoft Windows 2019` server platform, but should work on `Microsoft Windows 2016` and `Mirosoft Windows 10`

## Development

* Module `pscobol` was developed using `PDK 1.15` on Windows OS.
* It's released under an open MIT license. So, please feel free ot use it freely.
* Please do send the Pull Requests to add functionality for other platforms.

## Changelog

For updates please see the [changelog](https://github.com/umaritimus/pscobol/blob/master/CHANGELOG.md)
