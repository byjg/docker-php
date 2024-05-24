# Environment Variables

You don't need to replace the nginx configuration. The `byjg/php` image, you can adjust the NGINX configuration
and enable/disable modules. If fits for most of the users.

Any ENVIRONMENT variable can be accessible by your running PHP Instance.

## Change the Image Behaviour

### PHP_CONTROLLER=path

If set, will enable the PHP controller for the `fpm-nginx` and `fpm-apache` and
all requests will be directed to the PHP file specified.

```bash
docker run -e PHP_CONTROLLER=/app.php byjg/php:8.0-cli
```
### NGINX_ROOT=path

Changes the server root. Defaults to `/var/www/html`.

### PHP_FPM_SERVER=server:port

If set, will enable the FastCGI pass to the PHP-FPM server. Defaults to `127.0.0.1:9000`

### PHP_FPM_IGNORE_ENV=true

If set, with any value, will ignore the system environment variables in the PHP FPM

### NGINX_SSL_CERT and NGINX_SSL_CERT_KEY

If set, will enable to serve HTTPS pages.

```bash
docker run -v /etc/ssl:/etc/ssl \
  -e NGINX_SSL_CERT=/etc/ssl/my.cert \
  -e NGINX_SSL_CERT_KEY=/etc/ssl/my.key \
  byjg/php:8.0-fpm-ngnix
```

### DISABLEMODULE_[name]=true

All modules are installed by default. You can disable a module when you start the instance:

```bash
docker run -e DISABLEMODULE_DOM=true -e DISABLEMODULE_XSL=true byjg/php:8.0-cli
```

### VERBOSE=true

When you pass `VERBOSE=true` you can get a more verbose output about the entrypoint changes

```bash
docker run -e VERBOSE=true byjg/php:8.0-cli
```

## Read Only Environment Variables

### DOCKER_IMAGE (read only)

The name of the image is running.

### PHP_VERSION (read only)

The PHP Version is running (e.g. 8.2)

### PHP_VARIANT (read only)

The PHP variant is running (e.g. 8)

### BUILD_DATE (read only)

The date the image was built
