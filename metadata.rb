name             'gerrit'
maintainer       'MetaCloud, Inc.'
maintainer_email 'apenney@metacloud.com'
license          'Apache 2.0'
description      'Installs/Configures gerrit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'java'
depends 'git'
depends 'apache2'

supports 'debian'
