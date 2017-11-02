# Windows Templates for Packer

## Introduction

This repository contains Windows templates that can be used to create boxes for Vagrant using [Packer](http://www.packer.io). These templates are inspired by [boxcutter/windows](https://github.com/boxcutter/windows) and [joefitzgerald/packer-windows](https://github.com/joefitzgerald/packer-windows).

## Dependencies

- [Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `1.1.1+`
- [Virtualbox](https://www.virtualbox.org) 5.1.30+

## Windows Versions

The following Windows versions are currently supported:

 * Windows 10

## Using .box Files With Vagrant

The generated box files include a Vagrantfile template that is suitable for use with Vagrant 2.0.0+.

## How to Build the Images

1. Run:

    ```
    packer build <template-name>.json
    ```
