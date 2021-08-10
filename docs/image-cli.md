# PHP "*-cli" Images

The CLI images extends from "*-base" Image and have also:

- PHPUnit
- PHP Code Sniffer
- PHP Mess Detector
- PHP Code Beautifier and Fixer

You can create an alias to use easily the commands:

```bash
export PHP_VERSION="7.3"
alias php='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli php "$@"'
alias phpunit='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli phpunit "$@"'
alias phpcs='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli phpcs "$@"'
alias phpmd='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli phpmd "$@"'
alias composer='docker run -it --rm -v "$PWD":/workdir -v "$HOME/.composer:/.composer" -w /workdir -u $(id -u):$(id -g) byjg/php:$PHP_VERSION-cli composer "$@"'
```

and, when you execute, e.g. `php --version`, you have:

```text
PHP 7.3.27 (cli) (built: Feb  4 2021 21:04:33) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.3.27, Copyright (c) 1998-2018 Zend Technologies
    with Xdebug v2.9.8, Copyright (c) 2002-2020, by Derick Rethans
```

