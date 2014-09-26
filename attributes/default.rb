default['gerrit']['features']['user_management'] = true
default['gerrit']['features']['ssh']             = true
default['gerrit']['features']['ssl']             = true
default['gerrit']['features']['replication']     = false

default['gerrit']['version']     = '2.9.1'
default['gerrit']['group']       = 'gerrit'
default['gerrit']['user']        = 'gerrit'
default['gerrit']['home']        = '/var/gerrit'
default['gerrit']['install_dir'] = '/var/gerrit/review'

# The download location for gerrit, this is finished off with the version and .war.
default['gerrit']['download_location'] = 'https://gerrit-releases.storage.googleapis.com/gerrit'

default['gerrit']['core_plugins'] =
  %w(commit-message-length-validator replication reviewnotes download-commands)

default['gerrit']['theme']['compile_files'] = []
default['gerrit']['theme']['static_files']  = []

## We require Java 7 for Gerrit 2.9, so ensure we force this.
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version']    = '7'
default['java']['oracle']         = { accept_oracle_download_terms: true }

##
## Gerrit.config entries
##
default['gerrit']['config']['gerrit']['basePath']              = 'git'
default['gerrit']['config']['gerrit']['canonicalWebUrl']       = "http://#{node['hostname']}/"
default['gerrit']['config']['database']['type']                = 'H2'
default['gerrit']['config']['database']['database']            = 'db/ReviewDB'
default['gerrit']['config']['database']['hostname']            = 'localhost'
default['gerrit']['config']['database']['username']            = nil
default['gerrit']['config']['index']['type']                   = 'LUCENE'
default['gerrit']['config']['auth']['type']                    = 'OPENID'
default['gerrit']['config']['auth']['url']                     = nil
default['gerrit']['config']['sendemail']['smtpServer']         = 'localhost'
default['gerrit']['config']['container']['user']               = node['gerrit']['user']
default['gerrit']['config']['sshd']['listenAddress']           = '*:29418'
default['gerrit']['config']['cache']['directory']              = 'cache'
default['gerrit']['config']['httpd']['listenUrl']              = 'http://*:8080'

##
## Secure.config entries
##
#default['gerrit']['secure_config']['database']['password']            = nil
#default['gerrit']['secure_config']['auth']['registerEmailPrivateKey'] = nil
#default['gerrit']['secure_config']['auth']['restTokenPrivateKey']     = nil

##
## OS dependent settings.
##

case node['platform']
when 'debian', 'ubuntu'
  default['gerrit']['mysql-connector']['packages'] = ['libmysql-java']
end

# Need to create this so checks for subvalues don't fail if we don't create any.
default['gerrit']['ssh'] = {}
