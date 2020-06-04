FROM mediawiki AS orig
# This build stage is just a source for an unpatched file


FROM alpine AS build
# This build stage actually prepares all files

# Set up work directory
WORKDIR /home
RUN mkdir -p etc/apache2/sites-available var/www/html/extensions

# Get the 000-default.conf file and patch it
COPY --from=orig /etc/apache2/sites-available/000-default.conf\
 ./etc/apache2/sites-available/
COPY relative_url_root.patch /tmp/
RUN patch -p1 </tmp/relative_url_root.patch

# Install PluggableAuth extension
RUN for ext in LDAPAuthentication2-REL1_31-8bd6bc8.tar.gz \
               LDAPAuthorization-REL1_31-53e1ada.tar.gz \
               LDAPGroups-REL1_31-5a27bd8.tar.gz \
               LDAPProvider-REL1_31-7f81741.tar.gz \
               LDAPUserInfo-REL1_31-da95a07.tar.gz \
               Math-REL1_34-b1a022f.tar.gz \
               PluggableAuth-REL1_34-17fb1ea.tar.gz \
               Popups-REL1_34-375d27b.tar.gz \
               UploadWizard-REL1_34-e8b6892.tar.gz \
    ; do \
        wget -O/tmp/${ext} https://extdist.wmflabs.org/dist/extensions/${ext} && \
        tar -zxf /tmp/${ext} -C var/www/html/extensions; \
      done


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
