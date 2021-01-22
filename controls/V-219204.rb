# encoding: UTF-8

control 'V-219204' do
  title "The Ubuntu operating system must have system commands set to a mode of
0755 or less permissive."
  desc  "If the Ubuntu operating system were to allow any user to make changes
to software libraries, then those changes might be implemented without
undergoing the appropriate testing and approvals that are part of a robust
change management process.

    This requirement applies to Ubuntu operating systems with software
libraries that are accessible and configurable, as in the case of interpreted
languages. Software libraries also include privileged programs which execute
with escalated privileges. Only qualified and authorized individuals must be
allowed to obtain access to information system components for purposes of
initiating changes, including upgrades and modifications.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the system commands contained in the following directories have mode
0755 or less permissive:

    /bin
    /sbin
    /usr/bin
    /usr/sbin
    /usr/local/bin
    /usr/local/sbin

    Check that the system command files have mode 0755 or less permissive with
the following command:

    # find -L /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin
-perm /022 -type f -exec stat -c \"%n %a\" '{}' \\;

    If any files are found to be group-writable or world-writable, this is a
finding.
  "
  desc  'fix', "
    Configure the system commands to be protected from unauthorized access. Run
the following command:

    # sudo find -L /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin
-perm /022 -type f -exec chmod 755 '{}' \\;
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000259-GPOS-00100'
  tag gid: 'V-219204'
  tag rid: 'SV-219204r508662_rule'
  tag stig_id: 'UBTU-18-010139'
  tag fix_id: 'F-20928r304941_fix'
  tag cci: ['SV-109739', 'V-100635', 'CCI-001499']
  tag nist: ['CM-5 (6)']
end

