FROM mediawiki AS orig
# This build stage is just a source for an unpatched file


FROM alpine AS build
# This build stage actually prepares all files

# Set up work directory
WORKDIR /home
RUN mkdir -p\
 etc/apache2/mods-enabled\
 etc/apache2/sites-available

# Enable the desired modules: rewrite
RUN ln -s ../mods-available/rewrite.load etc/apache2/mods-enabled/

# Get the 000-default.conf file and patch it
COPY --from=orig /etc/apache2/sites-available/000-default.conf\
 ./etc/apache2/sites-available/
COPY relative_url_root.patch /tmp/
RUN patch -p1 </tmp/relative_url_root.patch


FROM mediawiki
# This build stage is the final output image

COPY --from=build /home/ /
