require "spec_helper"
require "serverspec"

describe file("/usr/local/sbin/cloudsshkey") do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
end

case os[:family]
when "openbsd"
  describe file("/etc/rc.local") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
    its(:content) { should match(/^#{Regexp.escape("/usr/local/sbin/cloudsshkey")}$/) }
  end

  describe file("/usr/local/sbin/cloud_set_guest_password") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
  end

  describe command("ls /var/db/dhclient.leases.*") do
    its(:exit_status) { should_not eq 0 }
  end

  describe file("/etc/rc.firsttime") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
    its(:content) { should match(/^# Managed by ansible$/) }
  end
when "freebsd"
  describe file("/usr/local/etc/rc.d/cloudsshkey") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
  end

  describe service("cloudsshkey") do
    it { should be_enabled }
  end

  describe file("/usr/local/sbin/cloud_set_guest_password") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
  end

  describe service("cloud_set_guest_password") do
    it { should be_enabled }
  end

  describe command("ls /var/db/dhclient.leases.*") do
    its(:exit_status) { should_not eq 0 }
  end

  describe file("/usr/local/etc/rc.d/cs_configinit") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
    its(:content) { should match(/^# Managed by ansible$/) }
  end

  describe file("/usr/local/sbin/cs_configinit") do
    it { should exist }
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "wheel" }
    its(:content) { should match(/^# Managed by ansible$/) }
  end

  describe service("cs_configinit") do
    it { should be_enabled }
  end
end
