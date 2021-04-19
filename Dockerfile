FROM mediawiki AS orig
# This build stage is just a source for an unpatched file


FROM alpine AS build
# This build stage actually prepares all files

# Install patch tool
# Run `docker build --no-cache .` to update dependencies
RUN apk add --no-cache patch

# Set up work directory
WORKDIR /home
RUN mkdir -p etc/apache2/sites-available var/www/html/extensions

# Get the 000-default.conf file and patch it
COPY --from=orig /etc/apache2/sites-available/000-default.conf\
 ./etc/apache2/sites-available/
COPY relative_url_root.patch /tmp/
RUN patch -p1 </tmp/relative_url_root.patch

# Install PluggableAuth extension
RUN ERR=0; \
    for ext in LDAPAuthentication2-REL1_36-635748c.tar.gz \
               LDAPAuthorization-REL1_36-a6f8420.tar.gz \
               LDAPGroups-REL1_36-0097b00.tar.gz \
               LDAPProvider-REL1_36-d318d26.tar.gz \
               LDAPUserInfo-REL1_36-e8a8823.tar.gz \
               Math-REL1_36-b0f07ee.tar.gz \
               PluggableAuth-REL1_36-d74e6e1.tar.gz \
               Popups-REL1_36-ddf574a.tar.gz \
               UploadWizard-REL1_36-6b1d096.tar.gz \
    ; do \
      wget -O/tmp/${ext} https://extdist.wmflabs.org/dist/extensions/${ext} && \
      tar -zxf /tmp/${ext} -C var/www/html/extensions || ERR=1; \
    done; \
    return $ERR

FROM mediawiki
# This build stage is the final output image

# 1. Install LDAP requirements
# 2. Install php ldap php-extensions
RUN set -x; \
    apt-get update && \
    apt-get install -y libldap2-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

COPY --from=build /home/ /
