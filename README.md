# PHP Docker Images ByJG

[![Opensource ByJG](https://img.shields.io/badge/opensource-byjg-success.svg)](http://opensource.byjg.com)
[![GitHub source](https://img.shields.io/badge/Github-source-informational?logo=github)](https://github.com/byjg/docker-php/)
[![Build Status](https://github.com/byjg/docker-php/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/byjg/docker-php/actions/workflows/build.yml)

**See full documentation at: [https://opensource.byjg.com/devops/docker-php](https://opensource.byjg.com/devops/docker-php)**

A complete and small PHP Docker image based on Alpine Linux and run on the archictectures

- amd64 (x86_64)
- arm64 (Raspberry PI, Graviton, etc) - available after February 2021

The Docker ByJG PHP Images has several bundled images based on PHP in different versions.

The PHP images are ready to use in:

- Development Environment
- Production Environment
- CI/CD environments (like Travis-CI, Circle-CI, Jenkis, Bitbucket Pipelines, and others)
- [IDE Integration](docs/ide.md)

## PHP Versions Available

|  Version     | Latest Version | Monthly Builds |
|:------------:|:--------------:|:--------------:|
| 8.3          | 8.3.1          | yes            |
| 8.2          | 8.2.14         | yes            |
| 8.1          | 8.1.27         | yes            |
| 8.0          | 8.0.30         | -              |
| 7.4          | 7.4.33         | -              |
| 7.3          | 7.3.33         | -              |
| 7.2          | 7.2.33         | -              |
| 7.1          | 7.1.33         | -              |
| 7.0          | 7.0.33         | -              |
| 5.6          | 5.6.40         | -              |

## PHP Images

Five different images for each PHP Version

- [base](docs/image-base.md) - Minimal Image, base for the other
- [cli](docs/image-cli.md) - PHP with Command Line installed (composer, phpunit, etc)
- [fpm](docs/image-fpm.md) - PHP with FPM installed
- [fpm-apache](docs/image-fpm.md) - PHP and Apache using FPM
- [fpm-nginx](docs/image-fpm.md) - PHP and Nginx using FPM

## Image Tag Convention

Since January 2021 de tag convention is:

```
byjg/php:<PHP_VERSION>-<TYPE>[-YYYY-MM]
```

Where:
- PHP_VERSION: It is `<MAJOR>.<MINOR>`, e.g `8.2`
- TYPE: It is `base`, `cli`,  `fpm`, `fpn-nginx`, `fpm-apache`
- YYYY: The Year of the Build
- MM: The month of the build.

The images without YYYY-MM can be updated to the latest PHP version and new features. 
The images with YYYY-MM are immutable

e.g.

```
byjg/php:8.2-fpm
```

## Environment variables

[Here](docs/environment.md) a list of environment variables.

 
## Image Sizes

Below a table with images uncompressed

|  Build Type  | Uncompressed Size |
|:------------:|:-----------------:|
|  base        |            ~135MB |
|  cli         |            ~154MB |
|  fpm         |            ~139MB |
|  fpm-nginx   |            ~154MB |
|  fpm-apache  |            ~154MB |


## Building your own image

Detailed instructions can be found [here](docs/building.md).

----
[Open source ByJG](http://opensource.byjg.com)
