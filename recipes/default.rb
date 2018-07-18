#
# Cookbook Name:: powercli_install
# Recipe:: default
#


case node['platform_family']
when 'debian'
  include_recipe 'apt'

  package 'curl'

  bash "Pull down and add the MS.key" do
    user "root"
    cwd "/tmp"
    creates "/tmp/MS.key"
    code <<-EOH
    STATUS=0
      curl https://packages.microsoft.com/keys/microsoft.asc > MS.key || STATUS=1
      apt-key add MS.key || STATUS=1
    exit $STATUS
    EOH
  end

  bash "Pull down and add the sources list" do
    user "root"
    cwd "/tmp"
    creates "/etc/apt/sources.list.d/microsoft.list"
    code <<-EOH
    STATUS=0
      curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list || STATUS=1
      apt-get update || STATUS=1
    exit $STATUS
    EOH
  end

  package 'powershell'

  bash "Trust the PSGallery" do
    user "root"
    cwd "/tmp"
    creates "/root/.ps_gallery_trusted"
    code <<-EOH
    STATUS=0
      pwsh -Command "& {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}" || STATUS=1
      touch /root/.ps_gallery_trusted || STATUS=1
    exit $STATUS
    EOH
  end


  bash "Install PowerCLI" do
    cwd "/tmp"
    code <<-EOH
    STATUS=0
      pwsh -Command "& {Install-Module -Name VMware.PowerCLI -Force}" || STATUS=1
    exit $STATUS
    EOH
  end

when 'rhel'
  package 'curl'

  bash "Install the Microsoft PowerShell Repo" do
    user "root"
    cwd "/tmp"
    creates "/etc/yum.repos.d/microsoft.repo"
    code <<-EOH
    STATUS=0
      curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/microsoft.repo     || STATUS=1
    exit $STATUS
    EOH
  end

  yum_package 'powershell' do
    action :install
    flush_cache [ :before ]
  end

  bash "Trust the PSGallery" do
    user "root"
    cwd "/tmp"
    creates "/root/.ps_gallery_trusted"
    code <<-EOH
    STATUS=0
      pwsh -Command "& {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}" || STATUS=1
      touch /root/.ps_gallery_trusted || STATUS=1
    exit $STATUS
    EOH
  end

  bash "Install PowerCLI" do
    user "root"
    cwd "/tmp"
    creates "/root/.powercli_installed"
    code <<-EOH
    STATUS=0
      pwsh -Command "& {Install-Module -Name VMware.PowerCLI -Force}" || STATUS=1
      touch /root/.powercli_installed || STATUS=1
    exit $STATUS
    EOH
  end

when 'windows'

  include_recipe 'powershell::powershell5'

  powershell_package 'Install PowerCLI' do
    action :install
    package_name %w(VMware.PowerCLI)
  end
end
