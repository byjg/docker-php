# PHP Docker Images ByJG

[![Opensource ByJG](https://img.shields.io/badge/opensource-byjg-success.svg)](http://opensource.byjg.com)

**See full documentation at: [https://opensource.byjg.com/devops/docker-php]()**

A complete and small PHP Docker image based on Alpine Linux and run on the archictectures
- amd64 (x86_64)
- arm64 (Raspberry PI, Graviton, etc) - available after February 2021

The Docker ByJG PHP Images has several bundled images based on PHP in different versions.

The PHP images are ready to use in:
 - Development Environment
 - Production Environment
 - CI/CD environments (like Travis-CI, Circle-CI, Jenkis, Bitbucket Pipelines, and others)
 - IDE Integration
 
## PHP Versions

- 8.0.0 (some extensions are not available yet)
- 7.4.13
- 7.3.25
- 7.2.33
- 7.1.33
- 7.0.33
- 5.6.40

## PHP Images

Five different images for each PHP Version

* [base](image-base) - Minimal Image, base for the other
* [cli](image-cli) - PHP with Command Line installed (composer, phpunit, etc)
* [fpm](image-fpm) - PHP with FPM installed
* [fpm-apache](image-fpm) - PHP and Apache using FPM
* [fpm-nginx](image-fpm) - PHP and Nginx using FPM

## Supported Tags

- 8.0-base
- 8.0-cli
- 8.0-fpm
- 8.0-fpm-apache
- 8.0-fpm-nginx
- 7.4-base
- 7.4-cli
- 7.4-fpm
- 7.4-fpm-apache
- 7.4-fpm-nginx
- 7.3-base
- 7.3-cli
- 7.3-fpm
- 7.3-fpm-apache
- 7.3-fpm-nginx
- 7.2-base
- 7.2-cli
- 7.2-fpm
- 7.2-fpm-apache
- 7.2-fpm-nginx
- 7.1-base
- 7.1-cli
- 7.1-fpm
- 7.1-fpm-apache
- 7.1-fpm-nginx
- 7.0-base
- 7.0-cli
- 7.0-fpm
- 7.0-fpm-apache
- 7.0-fpm-nginx
- 5.6-base
- 5.6-cli
- 5.6-fpm
- 5.6-fpm-apache
- 5.6-fpm-nginx

Since January 2021 all tags have also the suffix YYYY.MM. e.d
- 8.0-fpm-nginx-2021.01



## Image Sizes

Below a table with images uncompressed

| PHP Version   | base   | cli   | fpm    | fpm-nginx | fpm-apache |
|:-------------:|:------:|:-----:|:------:|:---------:|:----------:|
| 5.6           |   94MB | 131MB | 109MB  | 156MB     | 155MB      |
| 7.0           | 92.6MB | 136MB | 101MB  | 147MB     | 146MB      |
| 7.1           | 82.4MB | 126MB | 87MB   | 134MB     | 133MB      |
| 7.2           |   94MB | 140MB | 104MB  | 151MB     | 150MB      |
| 7.3           |   99MB | 151MB | 104MB  | 152MB     | 152MB      |

----
[Open source ByJG](http://opensource.byjg.com)

