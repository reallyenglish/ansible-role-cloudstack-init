# ansible-role-cloudstack-init

Initialize a host for cloudstack environment.

This role configure VMs to:

* install ssh key pair (`keypair` in `deployVirtualMachine`)
* update root password if available
* run `user-data` (`userdata` in `deployVirtualMachine`)

upon the next boot.

Also, the role does:

* clean up VM

`user-data` must be a binary or a script with no arguments. if it is a script,
the `user-data` must start with a valid `#!` line.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `cloudstack_init_dhclient_lease_dir` | path to directory where DHCP lease files are kept | `{{ __cloudstack_init_dhclient_lease_dir }}` |
| `cloudstack_init_interfaces` | list of interfaces that will be removed from DHCP lease files | `{{ __cloudstack_init_interfaces }}` |


## FreeBSD

| Variable | Default |
|----------|---------|
| `__cloudstack_init_dhclient_lease_dir` | `/var/db` |
| `__cloudstack_init_interfaces` | `["em0"]` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__cloudstack_init_dhclient_lease_dir` | `/var/db` |
| `__cloudstack_init_interfaces` | `["em0"]` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-cloudstack-init
  vars:
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```
`templates/cloud_set_guest_password.j2` is licensed under different license.
See the file for details.

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
