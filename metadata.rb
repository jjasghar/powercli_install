name 'powercli_install'
maintainer 'JJ Asghar'
maintainer_email 'jj@chef.io'
license 'Apache-2.0'
description 'Installs PowerCLI'
long_description 'Installs PowerCLI and PowerShell'
version '2.0.0'

chef_version '>= 12'

depends 'apt'
depends 'powershell'

%w(ubuntu debian redhat centos suse opensuse windows).each do |os|
  supports os
end

issues_url 'https://github.com/jjasghar/powercli_install/issues'
source_url 'https://github.com/jjasghar/powercli_install'
