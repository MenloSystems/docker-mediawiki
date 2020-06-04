MediaWiki image for Docker
==========================

MediaWiki image for Docker with support for serving from suburls and several
installed plugins.

This MediaWiki image is based on the [official -/mediawiki image][1] and
extended by a patch to serve from the suburl `/wiki`. Also includes
several plugins and their dependencies:

* [LDAPAuthentication2][2]
    * [LDAPProvider][6]
    * [PluggableAuth][7]
* [LDAPAuthorization][3]
    * [LDAPProvider][6]
    * [PluggableAuth][7]
* [LDAPGroups][4]
    * [LDAPProvider][6]
* [LDAPUserInfo][5]
    * [LDAPProvider][6]
* [UploadWizard][8]
* [Math][9]
* [Popups][10]

[1]: <https://hub.docker.com/_/mediawiki>
[2]: <https://www.mediawiki.org/wiki/Extension:LDAPAuthentication2>
[3]: <https://www.mediawiki.org/wiki/Extension:LDAPAuthorization>
[4]: <https://www.mediawiki.org/wiki/Extension:LDAPGroups>
[5]: <https://www.mediawiki.org/wiki/Extension:LDAPUserInfo>
[6]: <https://www.mediawiki.org/wiki/Extension:LDAPProvider>
[7]: <https://www.mediawiki.org/wiki/Extension:PluggableAuth>
[8]: <https://www.mediawiki.org/wiki/Extension:UploadWizard>
[9]: <https://www.mediawiki.org/wiki/Extension:Math>
[10]: <https://www.mediawiki.org/wiki/Extension:Popups>
