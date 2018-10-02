# Docker htpasswd Volumes

This Docker image will create dynamically htpasswd files to be used with other
docker containers that requires a htpasswd file.

## Basic Usage

You have to define at least 3 variables (HTCOUNT, USER1 and PWD1). Once the container is up and running will
have a file `/etc/htpasswd.d/htpasswd` with the passwords.

**Create the volume**

```bash
docker run \ 
    -e HTCOUNT=2 \
    -e USR1=john -e PWD1=mypassword \
    -e USR2=jane -e PWD2=herpassword \
    --name htpasswd-volume-instance \
    -t -d byjg/htpasswd-volume
```

**Attach the volume in your application**

```bash
docker run \
    ...
    --volumes-from htpasswd-volume-instance
    ...
```

Once you are running with --volumes-from you can refer inside your
docker container the file `/etc/htpasswd.d/htpasswd`

## Using Docker compose

```yaml
version: "3.4"
services:
  web:
    image: nginx
    volumes:
      - passwd:/auth
  htpasswd:
    environment:
      HTCOUNT: 2
      USR1: john
      PWD1: mypassword
      USR2: jane
      PWD2: otherpassword
    image: byjg/htpasswd-volume
    volumes:
      - passwd:/etc/htpasswd.d

volumes:
  passwd:
    driver: local
```


## Build

```
docker build -t byjg/htpasswd-volume:alpine .
```
