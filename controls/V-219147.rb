control 'V-219147' do
  title "Ubuntu operating systems booted with a BIOS must require
authentication upon booting into single-user and maintenance modes."
  desc  "To mitigate the risk of unauthorized access to sensitive information
by entities that have been issued certificates by DoD-approved PKIs, all DoD
systems (e.g., web servers and web portals) must be properly configured to
incorporate access control methods that do not rely solely on the possession of
a certificate for access. Successful authentication must not automatically give
an entity access to an asset or security boundary. Authorization procedures and
controls must be implemented to ensure each authenticated entity also has a
validated and current authorization. Authorization is the process of
determining whether an entity, once authenticated, is permitted to access a
specific asset. Information systems use access control policies and enforcement
mechanisms to implement this requirement.

    Access control policies include: identity-based policies, role-based
policies, and attribute-based policies. Access enforcement mechanisms include:
access control lists, access control matrices, and cryptography. These policies
and mechanisms must be employed by the application to control access between
users (or processes acting on behalf of users) and objects (e.g., devices,
files, records, processes, programs, and domains) in the information system.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify that an encrypted root password is set. This is only applicable on
systems that use a basic Input/Output System BIOS.

    Run the following command to verify the encrypted password is set:

    # grep –i password /boot/grub/grub.cfg

    password_pbkdf2 root
grub.pbkdf2.sha512.10000.MFU48934NJA87HF8NSD34493GDHF84NG

    If the root password entry does not begin with “password_pbkdf2”, this is a
finding.
  "
  desc 'fix', "
    Configure the system to require a password for authentication upon booting
into single-user and maintenance modes.

    Generate an encrypted (grub) password for root with the following command:

    # grub-mkpasswd-pbkdf2
    Enter Password:
    Reenter Password:
    PBKDF2 hash of your password is
grub.pbkdf2.sha512.10000.MFU48934NJD84NF8NSD39993JDHF84NG

    Using the hash from the output, modify the \"/etc/grub.d/40_custom\" file
with the following command to add a boot password:

    # sudo sed -i '$i set superusers=\\\"root\\\"\
    password_pbkdf2 root <hash>' /etc/grub.d/40_custom

    where <hash> is the hash generated by grub-mkpasswd-pbdkf2 command.

    Generate an updated \"grub.conf\" file with the new password by using the
following command:

    # update-grub
  "
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-OS-000080-GPOS-00048'
  tag gid: 'V-219147'
  tag rid: 'SV-219147r508662_rule'
  tag stig_id: 'UBTU-18-010000'
  tag fix_id: 'F-20871r304770_fix'
  tag cci: ['V-100519', 'SV-109623', 'CCI-000213']
  tag nist: ['AC-3']

  grub_superuser = input('grub_superuser')
  grub_main_cfg = input('grub_main_cfg')
  grub_main_content = file(grub_main_cfg).content

  if file('/sys/firmware/efi').exist?
    impact 0.0
    describe 'System running UEFI' do
      skip 'The System is running UEFI, this control is Not Applicable.'
    end
  else
    impact 0.7
    # Check if any additional superusers are set
    # Check does not state additional superusers is a finding
    # 'fix' required addition of the password to the 'root' user only, other superusers assumed to not be permitted for use.
    pattern = /\s*set superusers="(\w+)"/i
    matches = grub_main_content.match(pattern)
    superusers = matches.nil? ? [] : matches.captures
    describe "There must be only one grub superuser, and it must have the value #{grub_superuser}" do
      subject { superusers }
      its('length') { should cmp 1 }
      its('first') { should cmp grub_superuser }
    end

    # Need each password entry that has the superuser
    pattern = /(.*)\s#{grub_superuser}\s/i
    matches = grub_main_content.match(pattern)
    password_entries = matches.nil? ? [] : matches.captures
    # Each of the entries should start with password_pbkdf2
    describe 'The grub superuser password entry must begin with \'password_pbkdf2\'' do
      subject { password_entries }
      its('length') { is_expected.to be >= 1 }
      password_entries.each do |entry|
        subject { entry }
        it { should include 'password_pbkdf2' }
      end
    end

    # Get lines such as 'password_pbkdf2 root ${ENV}'
    matches = grub_main_content.match(pattern)
    pattern = /password_pbkdf2\s#{grub_superuser}\sgrub\.pbkdf2/i
    describe 'The grub superuser account password should be encrypted with pbkdf2.' do
      subject { grub_main_content }
      it { should match pattern }
    end
  end
end
