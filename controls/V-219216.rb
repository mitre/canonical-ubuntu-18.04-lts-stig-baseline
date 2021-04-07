# encoding: UTF-8

control 'V-219216' do
  title "The Ubuntu operating system must generate audit records for privileged
activities or other system-level access."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operating system audits privileged activities.

    Check the currently configured audit rules with the following command:

    # sudo auditctl -l | grep sudo.log

    -w /var/log/sudo.log -p wa -k priv_actions

    If the command does not return lines that match the example or the lines
are commented out, this is a finding.

    Notes: The '-k' allows for specifying an arbitrary identifier and the
string after it does not need to match the example output above.
  "
  desc  'fix', "
    Configure the Ubuntu operating system to audit privileged activities.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -w /var/log/sudo.log -p wa -k actions

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000471-GPOS-00215'
  tag gid: 'V-219216'
  tag rid: 'SV-219216r508662_rule'
  tag stig_id: 'UBTU-18-010237'
  tag fix_id: 'F-20940r304977_fix'
  tag cci: ['SV-109763', 'V-100659', 'CCI-000172']
  tag nist: ['AU-12 c']

  audit_file = '/var/log/sudo.log'

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

