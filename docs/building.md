---
sidebar_position: 5
---

# Building the Image

This project uses **Docker Buildx** to build multi-architecture container images for both `amd64` and `arm64` platforms.

The build process is a two-step workflow:
1. **Generate Dockerfiles** - Run `build.py` to create Dockerfiles from templates
2. **Build Images** - Manually run the generated Docker commands

## Prerequisites

### Required Tools

- **Python 3.x** - For running the Dockerfile generator
- **Docker** - With Buildx support (included in Docker 19.03+)
- **Docker Buildx** - For multi-platform builds

### Verify Docker Buildx

Check if Buildx is available:

```bash
docker buildx version
```

If not installed, see the [official Docker Buildx installation guide](https://docs.docker.com/buildx/working-with-buildx/). 

## Build Process

### Step 1: Generate Dockerfiles

The `build.py` script generates Dockerfiles and outputs the commands needed to build them.

#### Syntax

```bash
python3 build.py VERSION [OPTIONS]
```

#### Available Options

| Option               | Description                      |
|----------------------|----------------------------------|
| `--build-base`       | Generate base image Dockerfile   |
| `--build-cli`        | Generate CLI image Dockerfile    |
| `--build-fpm`        | Generate FPM image Dockerfile    |
| `--build-fpm-nginx`  | Generate FPM-Nginx Dockerfile    |
| `--build-fpm-apache` | Generate FPM-Apache Dockerfile   |
| `--build-nginx`      | Generate Nginx Dockerfile        |

#### Example: Generate Dockerfiles

```bash
# Generate all Dockerfiles for PHP 8.3
python3 build.py 8.3 --build-base --build-cli --build-fpm --build-fpm-nginx --build-fpm-apache

# Generate only CLI Dockerfile
python3 build.py 8.3 --build-cli
```

The script will:
1. Create Dockerfile files (e.g., `Dockerfile-php-8.3-base`, `Dockerfile-php-8.3-cli`)
2. Output Docker build commands to the console
3. Output Docker Buildx commands for multi-platform builds

### Step 2: Build Images Manually

After generating Dockerfiles, the script outputs commands that you need to run manually.

#### Local Build (Single Architecture)

For local testing on your current platform:

```bash
# Example output from build.py (copy and run these commands)
docker build -t byjg/php:8.3-base -f Dockerfile-php-8.3-base .
docker build -t byjg/php:8.3-base-2025.01 -f Dockerfile-php-8.3-base .
```

#### Multi-Platform Build with Buildx

For production builds supporting both `amd64` and `arm64`:

```bash
# Setup buildx (run once)
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap

# Build and push multi-platform images (example output from build.py)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t byjg/php:8.3-base \
  -f Dockerfile-php-8.3-base \
  --push .

docker buildx build --platform linux/amd64,linux/arm64 \
  -t byjg/php:8.3-base-2025.01 \
  -f Dockerfile-php-8.3-base \
  --push .
```

:::warning Build Order
When building multiple variants, always build `base` first, as `cli`, `fpm`, `fpm-nginx`, and `fpm-apache` depend on it.
:::

:::tip
The script automatically generates two tags for each image:
- `byjg/php:X.Y-type` - Latest version (updated monthly)
- `byjg/php:X.Y-type-YYYY.MM` - Immutable version-locked tag
:::

## Configuration Files

Configuration files for each PHP version are located in the `config/` directory with the naming pattern `php-{version}.yml`.

### Configuration Structure

```yaml
# The base image to use
image: alpine:edge

# (Optional) If we are getting packages from other resources, define them here
repositories:
  - https://dl-cdn.alpinelinux.org/alpine/edge/testing

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
    version: 2.5.5                  # optional - if not set, get the latest
    install: False                  # optional - do not call pecl install
    zend: True                      # optional - if true, add as zend extension
    config:                         # optional - if set, add extra config to php.ini 
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

# Temporary packages to be used to build the PECL packages 
peclBuildPackages:
  - autoconf
  - build-base

# Permanent packages to be installed in the image
additionalPackages:
  - libssl1.1
  - libcrypto1.1
```

## Complete Build Workflow Example

### Building All Variants for PHP 8.3

```bash
# Step 1: Install Python dependencies
pip install -r requirements.txt

# Step 2: Generate Dockerfiles for all variants
python3 build.py 8.3 \
  --build-base \
  --build-cli \
  --build-fpm \
  --build-fpm-nginx \
  --build-fpm-apache

# Step 3: Setup Docker Buildx (first time only)
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap

# Step 4: Build images in order (base must be first)
# Copy the commands output by build.py and run them

# Build base image
docker buildx build --platform linux/amd64,linux/arm64 \
  -t byjg/php:8.3-base \
  -f Dockerfile-php-8.3-base \
  --push .

# Build other variants (they depend on base)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t byjg/php:8.3-cli \
  -f Dockerfile-php-8.3-cli \
  --push .

# ... and so on for other variants
```

### Building for Local Testing (Single Platform)

If you just want to test locally without multi-platform support:

```bash
# Generate Dockerfiles
python3 build.py 8.3 --build-base --build-cli

# Build locally (single platform, no push)
docker build -t byjg/php:8.3-base -f Dockerfile-php-8.3-base .
docker build -t byjg/php:8.3-cli -f Dockerfile-php-8.3-cli .

# Test the image
docker run -it --rm byjg/php:8.3-cli php --version
```

## Managing Built Images

```bash
# List all Docker images
docker images | grep byjg/php

# Remove specific image
docker rmi byjg/php:8.3-cli

# Remove all dangling images
docker image prune

# Remove buildx builder
docker buildx rm mybuilder
```

## Customizing Builds

To create custom builds with different configurations:

1. **Modify existing configuration**: Edit files in `config/` directory
2. **Generate Dockerfiles**: Run `build.py` with your version
3. **Review generated Dockerfiles**: Check the generated files before building
4. **Build manually**: Run the Docker commands

See the [Configuration Structure](#configuration-structure) section for available configuration options.
