# Changelog

All notable changes to this project will be documented in this file.

## Release 1.2.3

**Features**

* Change powershell to pwsh provider for wider compatibility
* Allow null target for cobol compilation

**Bugfixes**

**Known Issues**


## Release 1.2.2

**Features**

* Path to the license could now be specified as a UNC location

**Bugfixes**

**Known Issues**


## Release 1.2.1

**Features**

**Bugfixes**

* Updated Readme

**Known Issues**


## Release 1.2.0

**Features**

* Added support for Visual Cobol 9 on Windows 2022 using Puppet 8
* Path to the license manager "lmpath" must be specified for license file installation

**Bugfixes**

**Known Issues**

* Only works on `Windows`

## Release 1.1.1

**Features**

**Bugfixes**

* Increased cobol installation and compilation timeouts for large environments
* Forced creation of a target symbolic link if symbolic link already exists by the same name

**Known Issues**

* Only works on `Windows`

## Release 1.1.0

**Features**

* Now compiles INAS cobol for PeopleSoft Campus Solutions

> Note: the above has only been verified using image CS92U016 on PeopleTools 8.57.12 on Windows 2019

**Bugfixes**

**Known Issues**

* Only works on `Windows`

## Release 1.0.4

**Features**

* Fixups to code
* Additional parameter verification and error checking

**Bugfixes**

**Known Issues**

* Only works on `Windows`
* Does not compile INAS cobol for PeopleSoft Campus Solutions (yet)

## Release 1.0.3

**Features**

* Fixups to code
* Additional parameter verification and error checking

**Bugfixes**

**Known Issues**

* Only works on `Windows`
* Does not compile INAS cobol for PeopleSoft Campus Solutions (yet)

## Release 1.0.2

**Features**

* Included additional and clarified existing examples
* Included additional debug statements and fixed class reference

**Bugfixes**

**Known Issues**

* Only works on `Windows`
* So far only `PS_HOME` cobol is tested.

## Release 1.0.1

**Features**

* Compiles cobol on a PeopleSoft target

**Bugfixes**

**Known Issues**

* Only works on `Windows`
* So far only `PS_HOME` cobol is tested.  Needs additional refactoring and fixups.

## Release 0.5.0

**Features**

* WARNING: Breaking changes - changed parameter names and types
* Added default base class and parameters
* Major code refactoring

**Bugfixes**

**Known Issues**

* Only works on `Windows`

## Release 0.4.0

**Features**

* Remove Linux compatibility designation for clarity
* Adjust changelog location on readme

**Bugfixes**

**Known Issues**

* Only works on `Windows`

## Release 0.3.1

**Features**

For `Micro Focus Visual Cobol`
* Install
* Install cumulative patch
* Register license
* Uninstall

**Bugfixes**

**Known Issues**

* Only works on `Windows`
