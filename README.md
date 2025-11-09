# PHP Docker Images ByJG

[![Opensource ByJG](https://img.shields.io/badge/opensource-byjg-success.svg)](http://opensource.byjg.com)
[![GitHub source](https://img.shields.io/badge/Github-source-informational?logo=github)](https://github.com/byjg/docker-php/)
[![Build Status](https://github.com/byjg/docker-php/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/byjg/docker-php/actions/workflows/build.yml)

## Overview

A complete, lightweight, and versatile PHP Docker image collection based on Alpine Linux. These images are designed to be small, efficient, and ready to use in various environments.

### Key Features

- **Lightweight**: Based on Alpine Linux, with optimized image sizes (~135-154MB)
- **Multi-architecture support**: Runs on amd64 (x86_64) and arm64 (Raspberry PI, Graviton)
- **Multiple PHP versions**: From PHP 5.6 to the latest PHP 8.4
- **Variety of configurations**: Base, CLI, FPM, FPM-Nginx, and FPM-Apache variants
- **Pre-installed extensions**: 45+ PHP extensions included in all images
- **Development tools**: Composer, PHPUnit, PHP Code Sniffer, and more in CLI images
- **Production-ready**: Optimized for both development and production environments

## Documentation Index

- [Base Image](docs/image-base.md) - Minimal image with 45+ extensions
- [CLI Image](docs/image-cli.md) - Command-line tools for development
- [FPM Images](docs/image-fpm.md) - PHP-FPM, Nginx, and Apache variants
- [Environment Variables](docs/environment.md) - Configuration options
- [Building Custom Images](docs/building.md) - Create your own images
- [IDE Integration](docs/ide.md) - Using with your IDE
- [Dockerfile Reference](docs/dockerfile.md) - Dockerfile details
- [Tagging Convention](docs/tagging.md) - Understanding image tags

**See full documentation at: [https://opensource.byjg.com/docs/devops/docker-php](https://opensource.byjg.com/docs/devops/docker-php)**

## Quick Start

```bash
# Pull an image
docker pull byjg/php:8.3-cli

# Run PHP
docker run -it --rm byjg/php:8.3-cli php --version

# Use with your project
docker run -v $PWD:/workdir -w /workdir byjg/php:8.3-cli php script.php
```

## Image Variants

Five different images for each PHP Version:

| Image Type   | Description                                             |
|--------------|---------------------------------------------------------|
| `base`       | Minimal image with 45+ PHP extensions and Composer      |
| `cli`        | Development tools (PHPUnit, PHP_CodeSniffer, PHPMD)     |
| `fpm`        | PHP-FPM for custom web server configurations            |
| `fpm-nginx`  | Complete LEMP stack (Nginx + PHP-FPM)                   |
| `fpm-apache` | Complete LAMP stack (Apache + PHP-FPM)                  |

## Supported PHP Versions

| Version | Latest Version | Monthly Builds | Alpine Version |
|:-------:|:--------------:|:--------------:|:--------------:|
| **8.5** |  **8.5.0RC2**  |    **yes**     |    **edge**    |
| **8.4** |   **8.4.13**   |    **yes**     |    **edge**    |
| **8.3** |   **8.3.26**   |    **yes**     |    **edge**    |
| **8.2** |  **8.2.29r2**  |    **yes**     |    **edge**    |
|   8.1   |     8.1.31     |       -        |      3.19      |
|   8.0   |     8.0.30     |       -        |      3.16      |
|   7.4   |     7.4.33     |       -        |      3.15      |
|   7.3   |     7.3.33     |       -        |      3.12      |
|   7.2   |     7.2.33     |       -        |      3.9       |
|   7.1   |     7.1.33     |       -        |      3.7       |
|   7.0   |     7.0.33     |       -        |      3.5       |
|   5.6   |     5.6.40     |       -        |      3.8       |

:::info
PHP versions with monthly builds receive regular updates. Legacy versions (without monthly builds) are no longer supported.
:::

:::warning
Images using Alpine `edge` are production-ready but may receive package updates. Pin to a specific YYYY.MM tag for guaranteed stability.
:::

## Use Cases

These images are ready to use in:

- **Development Environment** - Fast setup with all tools included
- **Production Environment** - Optimized, lightweight containers
- **CI/CD Pipelines** - Travis-CI, Circle-CI, Jenkins, Bitbucket Pipelines, GitHub Actions
- **IDE Integration** - Full PHP support without local installation (see [IDE Integration](docs/ide.md))

## Image Sizes

Uncompressed sizes for reference:

| Build Type | Uncompressed Size |
|:-----------|------------------:|
| base       |            ~135MB |
| cli        |            ~154MB |
| fpm        |            ~139MB |
| fpm-nginx  |            ~154MB |
| fpm-apache |            ~154MB |

---

[Open source ByJG](http://opensource.byjg.com)
