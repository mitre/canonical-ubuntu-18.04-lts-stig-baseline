# encoding: UTF-8

control 'V-219221' do
  title "The Ubuntu operating system must generate audit records for all
account creations, modifications, disabling, and termination events that affect
/etc/group."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).


  "
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operating system generates audit records for all account
creations, modifications, disabling, and termination events that affect
/etc/group.

    Check the currently configured audit rules with the following command:

    # sudo auditctl -l | grep group

    -w /etc/group -p wa -k usergroup_modification

    If the command does not return a line that matches the example or the line
is commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc  'fix', "
    Configure the Ubuntu operating system to generate audit records for all
account creations, modifications, disabling, and termination events that affect
/etc/group.

    Add or update the following rule to \"/etc/audit/rules.d/stig.rules\":

    -w /etc/group -p wa -k usergroup_modification

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000476-GPOS-00221'
  tag satisfies: ['SRG-OS-000476-GPOS-00221', 'SRG-OS-000239-GPOS-00089',
'SRG-OS-000240-GPOS-00090', 'SRG-OS-000241-GPOS-00091',
'SRG-OS-000303-GPOS-00120', 'SRG-OS-000458-GPOS-00203',
'SRG-OS-000463-GPOS-00207']
  tag gid: 'V-219221'
  tag rid: 'SV-219221r508662_rule'
  tag stig_id: 'UBTU-18-010245'
  tag fix_id: 'F-20945r304992_fix'
  tag cci: ['SV-109773', 'V-100669', 'CCI-002130', 'CCI-001404', 'CCI-001403',
'CCI-001405', 'CCI-000172']
  tag nist: ['AC-2 (4)', 'AC-2 (4)', 'AC-2 (4)', 'AC-2 (4)', 'AU-12 c']

  audit_file = '/etc/group'

  if file(audit_file).exist?
    impact 0.5
  else
    impact 0.0
  end

  describe auditd.file(audit_file) do
    its('permissions') { should include ['w'] }
    its('permissions') { should include ['a'] }
    its('action') { should_not include 'never' }
  end if file(audit_file).exist?

  describe "The #{audit_file} file does not exist" do
    skip "The #{audit_file} file does not exist, this requirement is Not Applicable."
  end if !file(audit_file).exist?
end

