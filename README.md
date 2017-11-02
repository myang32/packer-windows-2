# Windows Templates for Packer

## Introduction

This repository contains Windows templates that can be used to create boxes for Vagrant using [Packer](http://www.packer.io). These templates are inspired by [boxcutter/windows](https://github.com/boxcutter/windows) and [joefitzgerald/packer-windows](https://github.com/joefitzgerald/packer-windows).

## Windows Versions

The following Windows versions are currently supported:

 * Windows 10

## How to Run

### Dependencies

- [Virtualbox](https://www.virtualbox.org) 5.1.30+
- [Vagrant](https://www.vagrantup.com) 2.0.0+

### Procedure

To use the box:

1. Install the dependencies
1. Run `vagrant init ferrarimarco/windows` to initialize a `Vagrantfile` for this box
1. Run `vagrant up`

### Credentials
There is a `vagrant` user already configured, password: `vagrant`

### Example Vagrantfiles

See the `vagrantfile-templates` directory.

## Contributions
If you have suggestions, please create a new GitHub issue or pull request.

## How to Build

### Dependencies

- [Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `1.1.1+`
- [Virtualbox](https://www.virtualbox.org) 5.1.30+

### Dependencies

- GNU Make 4.1+
- Packer 1.1.1+
- Vagrant 2.0.0+
- Virtualbox 5.1.30+

### Build

1. Install the dependencies
1. Clone the repository
1. Run `make`
