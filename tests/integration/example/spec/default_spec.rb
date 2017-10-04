require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  describe server(:client1) do
    it "runs cloudsshkey" do
      r = current_server.ssh_exec("sudo /usr/local/etc/rc.d/cloudsshkey start")
      expect(r).to match(/Starting cloudsshkey/)
    end
    it "adds the key" do
      r = current_server.ssh_exec("sudo cat /root/.ssh/authorized_keys")
      expect(r).to match(/#{Regexp.escape("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaaUGnUNr+mdx2lbSFiL5yGe+dD4pEjInJtQo0pTVcLwIy+dym7wtwHO6aBPQdKTfapkRWEKPlRwArKx1/lPIMiAYtz57NMEdAdbKoCQdaGfAp0gB3Qe9rhxfMpGlsE+7gCRaqzgEBjQIXvh+nD3yVfovWQfCrl5I/zx/AplUSwe8UE02AJ/fnTGqrPt6TbilxwIhr2WYwLIZCXvgTRPF1QM1dK62kFxeEX4FMPRF3cl0glCQnyyofe4iwmjEPm7ch1gIDCw6epavsxG3wa2JurKRIUjgblVxxl6ga4z6ZOgQtmPeKyqe7akln7lzf+lVHuJdiHLPxV4ErlSeqmedX foo@bar")}/)
    end
  end
end
