# Building the image

Docker PHP Image uses [buildah](https://buildah.io/) 
to build a compatible [OCI container image](https://opencontainers.org/).

The image is compatible to all platforms, and it is capable to run on docker, 
podman, kubernetes and any other compatible with the OCI specification.

## Preparing the environment

Requirements:
* Python 3.x
* buildah

There is no necessary have docker installed, however you need to have the `buildah`
on your machine. 

If you are using an ubuntu/debian system you can use the provided script
`install-buildah-ubuntu.sh` to install it. 

## Command to build

```text
usage: build.py [-h] [--debug] [--build-base]
                [--build-cli] [--build-fpm]
                [--build-fpm-apache] [--build-fpm-nginx]
                [--push] 
                version
```

You can build one image only, but you need to make sure you have the `base` 
on your machine.

## The configuration file

The configuration for each environment is in the folder `config` and it is a yaml
file like this:

```yaml
# The base image to use
image: alpine:edge

# (Optional) If we are getting packages from other resources define here
repositories:
  - http://nl.alpinelinux.org/alpine/edge/testing

# The PHP Version
version:
  major: 8
  minor: 0

# List of extensions to be installed
extensions:
  - (NAME)
  - (NAME)

# The PECL extensions to be installed
pecl:
  - name: xdebug                    # required
    version: 2.5.5                  # optional - if not set get the latest
    install: False                  # optional - do not call pecl install
    zend: True                      # optional - if true, add as zend extension
    config:                         # optional - if set add extra config to php.ini 
      - xdebug.remote_port=9001     #            for this extension

# Composer packages to be installed
composer:
  packages:
    - phpunit/phpunit:*
    - squizlabs/php_codesniffer:*
    - phpmd/phpmd:@stable
  links:
    - phpunit
    - phpcs
    - phpbcbf
    - phpmd

# Nginx configuration
nginx:
  version: 1.17.9
  more_set_header_version: 0.33
  extensions:
    - (name)
    - (name)

# Temporary Packages to be used to build the PECL packages 
peclBuildPackages:
  - autoconf
  - build-base

# Permanent packages to be installed in the image
additionalPackages:
  - libssl1.1
  - libcrypto1.1
```

