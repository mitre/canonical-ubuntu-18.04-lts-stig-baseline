# encoding: UTF-8

control 'V-219240' do
  title "The Ubuntu operating system must generate audit records for
successful/unsuccessful uses of the mount command."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).
  "
  desc  'rationale', ''
  desc  'check', "
    Verify if the Ubuntu operating system generates audit records when
successful/unsuccessful attempts to use of the \"mount\" command occur.

    Check the configured audit rules with the following commands:

    # sudo auditctl -l | grep '/bin/mount'

    -a always,exit -F path=/bin/mount -F perm=x -F auid>=1000 -F auid!=-1 -k
privileged-mount

    If the command does not return lines that match the example or the lines
are commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc  'fix', "
    Configure the audit system to generate an audit event for any
successful/unsuccessful use of the \"mount\" command.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -a always,exit -F path=/bin/mount -F perm=x -F auid>=1000 -F
auid!=4294967295 -k privileged-mount

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag gid: 'V-219240'
  tag rid: 'SV-219240r508662_rule'
  tag stig_id: 'UBTU-18-010317'
  tag fix_id: 'F-20964r305049_fix'
  tag cci: ['V-100707', 'SV-109811', 'CCI-000172']
  tag nist: ['AU-12 c']

  audit_file = '/bin/mount'

  if file(audit_file).exist?
    impact 0.5
  else
    impact 0.0
  end

  describe auditd.file(audit_file) do
    its('permissions') { should include ['x'] }
    its('action.uniq') { should eq ['always'] }
    its('list.uniq') { should eq ['exit'] }
  end if file(audit_file).exist?

  describe "The #{audit_file} file does not exist" do
    skip "The #{audit_file} file does not exist, this requirement is Not Applicable."
  end if !file(audit_file).exist?
end

