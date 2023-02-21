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
- [IDE Integration](ide)

## PHP Versions

### "Live" versions

- 8.2.3
- 8.1.16
- 8.0.28

### Versions are not updated

- 7.4.26
- 7.3.33
- 7.2.33
- 7.1.33
- 7.0.33
- 5.6.40

## PHP Images

Five different images for each PHP Version

- [base](image-base) - Minimal Image, base for the other
- [cli](image-cli) - PHP with Command Line installed (composer, phpunit, etc)
- [fpm](image-fpm) - PHP with FPM installed
- [fpm-apache](image-fpm) - PHP and Apache using FPM
- [fpm-nginx](image-fpm) - PHP and Nginx using FPM

## Environment variables

[Here](environment) a list of environment variables.

## Supported Tags

| Tag            | Montly builds |
|:---------------|:-------------:|
| 8.2-base       |      yes      |
| 8.2-cli        |      yes      |
| 8.2-fpm        |      yes      |
| 8.2-fpm-apache |      yes      |
| 8.2-fpm-nginx  |      yes      |
| 8.1-base       |      yes      |
| 8.1-cli        |      yes      |
| 8.1-fpm        |      yes      |
| 8.1-fpm-apache |      yes      |
| 8.1-fpm-nginx  |      yes      |
| 8.0-base       |      yes      |
| 8.0-cli        |      yes      |
| 8.0-fpm        |      yes      |
| 8.0-fpm-apache |      yes      |
| 8.0-fpm-nginx  |      yes      |
| 7.4-base       |      yes      |
| 7.4-cli        |      yes      |
| 7.4-fpm        |      yes      |
| 7.4-fpm-apache |      yes      |
| 7.4-fpm-nginx  |      yes      |
| 7.3-base       |       -       |
| 7.3-cli        |       -       |
| 7.3-fpm        |       -       |
| 7.3-fpm-apache |       -       |
| 7.3-fpm-nginx  |       -       |
| 7.2-base       |       -       |
| 7.2-cli        |       -       |
| 7.2-fpm        |       -       |
| 7.2-fpm-apache |       -       |
| 7.2-fpm-nginx  |       -       |
| 7.1-base       |       -       |
| 7.1-cli        |       -       |
| 7.1-fpm        |       -       |
| 7.1-fpm-apache |       -       |
| 7.1-fpm-nginx  |       -       |
| 7.0-base       |       -       |
| 7.0-cli        |       -       |
| 7.0-fpm        |       -       |
| 7.0-fpm-apache |       -       |
| 7.0-fpm-nginx  |       -       |
| 5.6-base       |       -       |
| 5.6-cli        |       -       |
| 5.6-fpm        |       -       |
| 5.6-fpm-apache |       -       |
| 5.6-fpm-nginx  |       -       |

Since January 2021 all tags have also the suffix YYYY.MM. e.d
- 8.0-fpm-nginx-2021.01

## Image Sizes

Below a table with images uncompressed

| PHP Version   | base  | cli   | fpm    | fpm-nginx | fpm-apache |
|:-------------:|:-----:|:-----:|:------:|:---------:|:----------:|
| 8.0           | 136MB | 154MB | 145MB  | 156MB     | 156MB      |
| 7.4           | 136MB | 154MB | 144MB  | 156MB     | 156MB      |
| 7.3           | 104MB | 123MB | 109MB  | 161MB     | 161MB      |
| 7.2           | 106MB | 124MB | 111MB  | 157MB     | 157MB      |
| 7.1           | 101MB | 119MB | 105MB  | 151MB     | 150MB      |
| 7.0           | 117MB | 136MB | 125MB  | 170MB     | 169MB      |
| 5.6           | 103MB | 122MB | 127MB  | 173MB     | 173MB      |

## Building your own image

Detailed instructions can be found [here](building).

----
[Open source ByJG](http://opensource.byjg.com)
