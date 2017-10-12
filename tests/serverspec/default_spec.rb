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
end
