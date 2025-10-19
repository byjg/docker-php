# PHP "*-cli" Images

The CLI images extend from the "*-base" image and also include:

- PHPUnit
- PHP Code Sniffer
- PHP Mess Detector
- PHP Code Beautifier and Fixer

You can create aliases to easily use the commands:

```bash
export PHP_VERSION="8.4"
alias php='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli php'
alias composer='docker run -it --rm -v "$PWD":/workdir -v "$HOME/.composer:/.composer" -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli composer'
```

When you execute, e.g., `php --version`, you will see:

```text
PHP 8.4.13 (cli) (built: Sep 23 2025 19:01:29) (NTS)
Copyright (c) The PHP Group
Built by Alpine Linux aports
Zend Engine v4.4.13, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.13, Copyright (c), by Zend Technologies
    with Xdebug v3.4.6, Copyright (c) 2002-2025, by Derick Rethans
```

