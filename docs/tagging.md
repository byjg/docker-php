---
sidebar_position: 8
---

# Tagging Convention

## Tag Format

```text
byjg/php:{PHP_VERSION}-{IMAGE_TYPE}[-{YEAR}.{MONTH}]
```

## Quick Reference

### PHP Versions

| PHP Version | Status      | Latest Release | Support End Date |
|-------------|-------------|----------------|------------------|
| 8.4         | Latest      | 2024.10        | Nov 2027         |
| 8.3         | Supported   | 2024.10        | Nov 2026         |
| 8.2         | Supported   | 2024.10        | Dec 2025         |
| 8.1         | End of Life | 2024.10        | Nov 2024         |
| 8.0         | End of Life | 2024.01        | Nov 2023         |
| 7.4         | End of Life | 2023.05        | Nov 2022         |
| 7.3         | End of Life | 2021.12        | Dec 2021         |
| 7.2         | End of Life | 2021.06        | Nov 2020         |
| 7.1         | End of Life | 2021.06        | Dec 2019         |
| 7.0         | End of Life | 2021.06        | Dec 2018         |
| 5.6         | End of Life | 2021.06        | Dec 2018         |

### Image Types

| Image Type   | Description                                             |
|--------------|---------------------------------------------------------|
| `base`       | A minimal image with PHP                                |
| `cli`        | An image ready to use as a PHP command line replacement |
| `fpm`        | An image with PHP-FPM ready to use                      |
| `fpm-nginx`  | An image bundled with PHP+FPM+NGinx                     |
| `fpm-apache` | An image bundled with PHP+FPM+APACHE (since 2021.01)    |

## Usage Examples

### Latest Version (Updated Monthly)
```bash
docker pull byjg/php:8.3-cli
```

### Version Locked for Production
```bash
docker pull byjg/php:8.3-cli-2024.10
```

> **Important**: For production environments, we strongly recommend using version-locked images with the `{YEAR}.{MONTH}` suffix to ensure stability. The standard tags without date suffixes are updated monthly and may introduce changes.

## Available Releases by Year

### 2025 Releases

| Month | PHP 8.4 | PHP 8.3 | PHP 8.2 | PHP 8.1 |
|-------|---------|---------|---------|---------|
| 03    | ✓       | ✓       | ✓       | ✓       |

```bash
docker pull byjg/php:8.4-cli-2025.03
```

### 2024 Releases

| Month | PHP 8.4 | PHP 8.3 | PHP 8.2 | PHP 8.1 | PHP 8.0 |
|-------|---------|---------|---------|---------|---------|
| 10    | ✓       | ✓       | ✓       | ✓       |         |
| 06    |         | ✓       | ✓       | ✓       |         |
| 05    |         | ✓       | ✓       | ✓       |         |
| 04    |         | ✓       | ✓       | ✓       |         |
| 01    |         | ✓       | ✓       | ✓       | ✓       |

```bash
docker pull byjg/php:8.3-fpm-nginx-2024.10
```

### 2023 Releases

| Month | PHP 8.3 | PHP 8.2 | PHP 8.1 | PHP 8.0 | PHP 7.4 |
|-------|---------|---------|---------|---------|---------|
| 10    | ✓       | ✓       | ✓       | ✓       |         |
| 06    | ✓       | ✓       | ✓       | ✓       |         |
| 05    |         | ✓       | ✓       | ✓       | ✓       |
| 04    |         | ✓       | ✓       | ✓       |         |
| 03    |         | ✓       | ✓       | ✓       |         |
| 02    |         | ✓       | ✓       | ✓       |         |
| 01    |         | ✓       | ✓       | ✓       | ✓       |

```bash
docker pull byjg/php:8.2-fpm-2023.10
```

### 2022 Releases

| Month | PHP 8.2 | PHP 8.1 | PHP 8.0 | PHP 7.4 |
|-------|---------|---------|---------|---------|
| 12    | ✓       | ✓       | ✓       | ✓       |
| 11    | ✓       | ✓       | ✓       | ✓       |
| 10    | ✓       | ✓       | ✓       | ✓       |
| 08    |         | ✓       | ✓       | ✓       |
| 07    |         | ✓       | ✓       | ✓       |
| 06    |         | ✓       | ✓       | ✓       |
| 05    |         | ✓       | ✓       | ✓       |
| 04    |         | ✓       | ✓       | ✓       |
| 03    |         | ✓       | ✓       | ✓       |
| 01    |         |         | ✓       | ✓       |

```bash
docker pull byjg/php:8.1-base-2022.12
```

### 2021 Releases

| Month | PHP 8.0 | PHP 7.4 | PHP 7.3 | PHP 7.2 | PHP 7.1 | PHP 7.0 | PHP 5.6 |
|-------|---------|---------|---------|---------|---------|---------|---------|
| 12    | ✓       | ✓       | ✓       |         |         |         |         |
| 11    | ✓       | ✓       | ✓       |         |         |         |         |
| 10    | ✓       | ✓       | ✓       |         |         |         |         |
| 09    | ✓       | ✓       | ✓       |         |         |         |         |
| 08    | ✓       | ✓       | ✓       |         |         |         |         |
| 07    | ✓       | ✓       | ✓       |         |         |         |         |
| 06    | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       |
| 05    |         |         | ✓       | ✓       | ✓       | ✓       | ✓       |
| 02    | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       |
| 01    | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       | ✓       |

```bash
docker pull byjg/php:7.4-cli-2021.12
```


