gerrit Cookbook
===============

This cookbook configures Gerrit, a code review system.  It handles aquisition
of the war file and the full configuration to stand up Gerrit.

Requirements
------------

## Ohai and Chef:

This was tested against Chef 11.

## Cookbooks:

We require the java cookbook for setting up a JDK to run Gerrit with.  We also
need git (as gerrit operates by managing git, effectively), as well as the
'apache2' cookbook for setting up proxying.

Attributes
==========

This cookbook has a number of attributes, divided into sections.

Feature Flags
-------------
* `node['gerrit']['features']['user_management']` - Toggles creation of user/group for Gerrit.
* `node['gerrit']['features']['ssh']` - Toggles management of SSH keys for Gerrit.
* `node['gerrit']['features']['ssl']` - Toggles SSL key management for Gerrit. (Also for Apache proxying)
* `node['gerrit']['features']['replication']` - Toggles if replication should be enabled.

Installation
------------

* `node['gerrit']['version']` - Version of Gerrit to install.
* `node['gerrit']['group']` - Name of the group to use for Gerrit.
* `node['gerrit']['user']` - Name of the user to use for Gerrit.
* `node['gerrit']['home']` - Home directory location for Gerrit.
* `node['gerrit']['install_dir']` - Where to install Gerrit to.
* `node['gerrit']['download_location']` - Where to download Gerrit from.
* `node['gerrit']['core_plugins']` - Which plugins to install with Gerrit.
* `node['gerrit']['theme']['compile_files']` - Which additional theme files to install.
* `node['gerrit']['theme']['static_files']` - Which additional static theme files to install.

Java
----

Gerrit requires Java 7 so we enforce this below.

* `node['java']['install_flavor']` - Which version of Java to install. (Oracle by default)
* `node['java']['jdk_version']` - Which version of the JDK to install. (7)
* `node['java']['oracle']` - A hash to pass to the java cookbook, which allows us to accept the license by default.

Configuration
-------------

* `node['gerrit']['config']['gerrit']['basePath']` - The basePath to use for git.
* `node['gerrit']['config']['gerrit']['canonicalWebUrl']` - The full URL for gerrit.
* `node['gerrit']['config']['database']['type']` - What kind of database to use.
* `node['gerrit']['config']['database']['database']` - Name of the actual database.
* `node['gerrit']['config']['database']['hostname']` - Hostname the database is hosted on.
* `node['gerrit']['config']['database']['username']` - Username to connect to the database with.
* `node['gerrit']['config']['index']['type']` - What kind of search index to use.
* `node['gerrit']['config']['auth']['type']` - What kind of authentication to enable.
* `node['gerrit']['config']['auth']['url']` - The URL of the authentication service.
* `node['gerrit']['config']['sendemail']['smtpServer']` - What SMTP server to send mail with.
* `node['gerrit']['config']['container']['user']` - The container user to use.
* `node['gerrit']['config']['sshd']['listenAddress']` - Where to listen for incoming SSH. (Used by Zuul)
* `node['gerrit']['config']['cache']['directory']` - Cache directory to use.
* `node['gerrit']['config']['httpd']['listenUrl']` - Where to listen over HTTP.

Secure Configuration values
---------------------------

These are special cased and placed into secure.conf instead of the main configuration file.

* `node['gerrit']['secure_config']['database']['password']` - Password to connect to the database.
* `node['gerrit']['secure_config']['auth']['registerEmailPrivateKey']` - Private key to use for email.
* `node['gerrit']['secure_config']['auth']['restTokenPrivateKey']` - Private token for REST.

Packages
--------

* `node['gerrit']['mysql-connector']['packages']` - List of packages needed for MySQL connectivity.

Usage
-----
#### gerrit::default

Almost all functionality is included through the main cookbook.

e.g.
Just include `gerrit` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[gerrit]"
  ]
}
```

License and Authors
-------------------

This cookbook draws enormous inspiration from the [Typo3 Gerrit
cookbook](https://github.com/TYPO3-cookbooks/gerrit).  As this was my first
cookbook I borrowed liberally from their work and I want to thank them
publically for publishing it!.

Authors: Ashley Penney <apenney@metacloud.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
