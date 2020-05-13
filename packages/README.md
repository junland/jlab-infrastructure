# Packages

This repo is for creating arbitrary packages that are not supplied by OS distribution repositories.

## Notes

* Use `<rh dist>/<maj ver>/<arch>/RPMS` in bintray for RPMs.

* Below is the standard paths for the repos.
  ```
    OS-DISTRO
    ├── VER
    │   ├── aarch64
    │   │   ├── repodata
    │   │   │   └── repomd.xml
    │   │   └── RPMS
    │   │       └── mypackage.rpm
    │   └── x86_64
    │       ├── repodata
    │       │   └── repomd.xml
    │       └── RPMS
    │           └── mypackage.rpm
    └── VER
        ├── aarch64
        │   ├── repodata
        │   │   └── repomd.xml
        │   └── RPMS
        │       └── mypackage.rpm
        └── x86_64
            ├── repodata
            │   └── repomd.xml
            └── RPMS
                └── mypackage.rpm
  ```

## How to add new version to bintray.

```
jfrog bt vc junland/jlab/<program name>/<version name>
```

```
jfrag bt u "somedir/*.rpm" junland/jlab/<program name>/<version name> DISTRO/VER/ARCH/RPMS
```