---
sidebar_position: 2
---

# PHP "*-cli" Images

The CLI images extend from the `*-base` image and include additional development tools.

## Included Development Tools

The CLI images come with these pre-installed tools:

- **PHPUnit** - PHP testing framework
- **PHP_CodeSniffer** - Code style checker and fixer
- **PHPMD** - PHP Mess Detector for code quality
- **PHPCBF** - PHP Code Beautifier and Fixer

## Usage

### Quick Start with Shell Aliases

For convenient usage, create shell aliases:

```bash title="~/.bashrc or ~/.zshrc"
export PHP_VERSION="8.4"
alias php='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli php'
alias composer='docker run -it --rm -v "$PWD":/workdir -v "$HOME/.composer:/.composer" -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli composer'
alias phpunit='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli phpunit'
alias phpcs='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli phpcs'
```

### Example Output

When you execute `php --version`:

```
PHP 8.4.13 (cli) (built: Sep 23 2025 19:01:29) (NTS)
Copyright (c) The PHP Group
Built by Alpine Linux aports
Zend Engine v4.4.13, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.13, Copyright (c), by Zend Technologies
    with Xdebug v3.4.6, Copyright (c) 2002-2025, by Derick Rethans
```

### Running Development Tools

```bash
# Run PHPUnit tests
docker run -v $PWD:/workdir -w /workdir byjg/php:8.3-cli phpunit

# Run PHP_CodeSniffer
docker run -v $PWD:/workdir -w /workdir byjg/php:8.3-cli phpcs src/

# Install Composer dependencies
docker run -v $PWD:/workdir -w /workdir byjg/php:8.3-cli composer install
```

:::tip
Mount your `.composer` directory to persist Composer cache across container runs for faster dependency installation.
:::

