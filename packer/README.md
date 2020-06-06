# Homelab Packer

Contains various Packer configurations for my home VM / Dev infrastructure.

_Repo is based upon [stardata/packer-centos7-kvm-example](https://github.com/stardata/packer-centos7-kvm-example)_

## Configs

* `centos8-base.json` - Base CentOS 8 image with a 95 GB primary hard disk.
    * `docker-ce` pre-installed.
    * `git` pre-installed.
    * `epel` repository enabled.
    * Basic monitoring tools installed.
* `centos8-faas.json` - CentOS 8 image with a 100 GB primary hard disk, image is for using openFaaS.
    * `docker-ce` pre-installed.
    * `open-faas` pre-installed w/ access to `docker`.
    * `git` pre-installed.
    * `epel` repository enabled.
    * Basic monitoring tools installed.
* `centos8-gitlab.json` - CentOS 8 image with a 100 GB primary hard disk, image is for deploying Gitlab Runners.
    * `docker-ce` pre-installed.
    * `gitlab-runner` pre-installed w/ access to `docker`.
    * `git` pre-installed.
    * `epel` repository enabled.
    * Basic monitoring tools installed.

## Building

_To build a config you must have `packer` installed (Availiable through your package manager or you can get pre-built binaries on the packer.io website)._

To build, issue this command below with the config that you want to build.
```
packer build <json config file>
```

If you need to debug the build, issue this command.
```
PACKER_LOG=1 packer build <json config file>
```
