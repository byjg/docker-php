# PHP Image tag

The pattern for tagging the images is:

```text
{PHP_VERSION}-{IMAGE_TYPE}
```

Where PHP_VERSION can be:
- 8.0
- 7.4
- 7.3
- 7.2
- 7.1
- 7.0
- 5.6

And IMAGE_TYPE can be:
- base: a minimal image with PHP
- cli: an image ready to use as a PHP command line replacement
- fpm: an image with the PHP ready to use
- fpm-nginx: an image bundled PHP+FPM+NGinx
- fpm-apache: an image bundled PHP+FPM+APACHE

Example:

```bash
docker pull byjg/php:7.3-cli
```

```tip
This tagging are always pointing to the latest version and they are updated monthly.
For production environments we recommend use an image that does not change monthly.
To have this just add the suffix {YEAR}{MONTH}

e.g.

docker pull byjg/php:7.3-cli-2021.01
```
