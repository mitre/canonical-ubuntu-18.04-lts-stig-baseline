# Ansible Ubuntu Base

[![Travis CI](https://img.shields.io/travis/fabschurt/ansible-role-ubuntu-base/master.svg)](https://travis-ci.org/fabschurt/ansible-role-ubuntu-base)

This is a very simple Ansible role that can be used to set up a bare Ubuntu
system.

Here’s a (non-exhaustive) list of the changes that it will implement:

* *src* and *backport* APT repositories will be disabled
* package cache will be updated and all packages upgraded
* some very vital packages will be installed
* some locales will be activated/generated
* Postfix will be installed and configured as a *send-only* relay (no incoming
  mail)

## Requirements

* Ubuntu 18.04 remote host(s) with root access
* Ansible >= 2.4

## Role variables

This role is configurable with the following variables:

* `installed_locales`: a collection of locales that must be installed on the
  system
* `postmaster_redirect_address`: an e-mail address where *postmaster*/*root*
  e-mails will be redirected to

See the [Example playbook](#example-playbook) section below for a reference of
these variables’ default values.

## Example playbook

This is an example playbook that demonstrates how you would use the role,
provided that you’ve [installed](https://galaxy.ansible.com/docs/using/installing.html)
it already. The variable values used here reflect the default values declared in
`defaults/main.yml`:

```yaml
- hosts: …
  roles:
    - role: fabschurt.ubuntu_base
      installed_locales:
        - en_US.UTF-8
        - en_IE.UTF-8
      postmaster_redirect_address: root@localhost # You should really override this variable
```

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).
