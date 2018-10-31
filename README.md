MediaWiki image for Docker
==========================

MediaWiki image for Docker with support for serving from suburls.

This MediaWiki image is based on the [official -/mediawiki image][1] and
extended by a patch to react to a variable `RELATIVE_URL_ROOT`.

[1]: https://hub.docker.com/_/mediawiki


RELATIVE_URL_ROOT variable
--------------------------

If the container is started with a `RELATIVE_URL_ROOT` environment
variable set to `/foo/bar`, it will serve mediawiki from that URL
instead of from `/`.
