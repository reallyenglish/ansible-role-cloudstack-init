require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  # rubocop:disable Metrics/BlockLength
  [
    server(:freebsd103),
    server(:openbsd60),
    server(:openbsd61)
  ].each do |s|
    describe s do
      let(:initial_password) do
        current_server.ssh_exec("sudo getent passwd root | cut -d':' -f2")
      end

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

      let(:passwd_command) do
        command = ""
        r = current_server.ssh_exec "uname -s"
        case r.chomp.downcase
        when "freebsd"
          command = "/usr/local/sbin/cloud_set_guest_password"
        when "openbsd"
          command = "/usr/local/sbin/cloud_set_guest_password"
        end
        command
      end

      it "gets initial password" do
        expect(initial_password).not_to eq ""
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

      it "runs cloud_set_guest_password" do
        r = current_server.ssh_exec("sudo #{passwd_command} >/dev/null 2>&1 && echo -n OK")
        expect(r).to eq "OK"
      end

      it "has root password updated" do
        password = current_server.ssh_exec("sudo getent passwd root | cut -d':' -f2")
        expect(password.chomp).not_to eq initial_password
      end
    end
  end
  [
    server(:openbsd60),
    server(:openbsd61)
  ].each do |s|
    describe s do
      it "runs /etc/rc.firsttime" do
        r = current_server.ssh_exec("sudo sh /etc/rc.firsttime >/dev/null 2>&1 && echo -n OK")
        expect(r).to eq "OK"
      end

      it "runs the content of user-data" do
        r = current_server.ssh_exec("ls -al /foo >/dev/null 2>&1 && echo -n OK")
        expect(r).to eq "OK"
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
