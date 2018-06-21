#
# Cookbook Name:: powercli_install
# Spec:: default
#
# Copyright:: 2018, JJ Asghar

describe port(80) do
  it { should_not be_listening }
end

describe port(443) do
  it { should_not be_listening }
end

if os[:family] == 'debian'
  describe directory('/opt/microsoft/powershell') do
    it { should exist }
  end
elsif os[:family] == 'redhat'
  describe directory('/opt/microsoft/powershell') do
    it { should exist }
  end
end

describe command('pwsh -Command "{& Get-InstalledModule -Name VMware.PowerCLI}"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should_not be_empty }
end
