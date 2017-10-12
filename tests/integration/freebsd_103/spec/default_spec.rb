require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  [
    server(:freebsd103),
    server(:openbsd60),
    server(:openbsd61),
  ].each do |s|
    describe s do
      let(:start_command) do
        command = ""
        r = current_server.ssh_exec "uname -s"
        case r.chomp.downcase
        when "freebsd"
          command = "sudo service cloudsshkey start"
        when "openbsd"
          command = "sudo /usr/local/sbin/cloudsshkey"
        end
        command
      end
      let(:successful_message) do
        msg = ""
        r = current_server.ssh_exec "uname -s"
        case r.chomp.downcase
        when "freebsd"
          msg = /^Starting cloudsshkey\.$/
        when "openbsd"
          # XXX the script does not output anything
          msg = /.*/
        end
        msg
      end

      it "runs cloudsshkey" do
        r = current_server.ssh_exec(start_command)
        expect(r || "").to match(successful_message)
      end
      it "adds the key" do
        r = current_server.ssh_exec("sudo cat /root/.ssh/authorized_keys")
        expect(r).to match(/#{Regexp.escape("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaaUGnUNr+mdx2lbSFiL5yGe+dD4pEjInJtQo0pTVcLwIy+dym7wtwHO6aBPQdKTfapkRWEKPlRwArKx1/lPIMiAYtz57NMEdAdbKoCQdaGfAp0gB3Qe9rhxfMpGlsE+7gCRaqzgEBjQIXvh+nD3yVfovWQfCrl5I/zx/AplUSwe8UE02AJ/fnTGqrPt6TbilxwIhr2WYwLIZCXvgTRPF1QM1dK62kFxeEX4FMPRF3cl0glCQnyyofe4iwmjEPm7ch1gIDCw6epavsxG3wa2JurKRIUjgblVxxl6ga4z6ZOgQtmPeKyqe7akln7lzf+lVHuJdiHLPxV4ErlSeqmedX foo@bar")}/)
      end

      it "has /root/.ssh with correct permission" do
        r = current_server.ssh_exec("export `sudo stat -s /root/.ssh` ; echo -n $st_mode")
        expect(r).to eq "040700"
      end

      it "has /root/.ssh/authorized_keys with correct permission" do
        r = current_server.ssh_exec("export `sudo stat -s /root/.ssh/authorized_keys` ; echo -n $st_mode")
        expect(r).to eq "0100600"
      end
    end
  end
end
