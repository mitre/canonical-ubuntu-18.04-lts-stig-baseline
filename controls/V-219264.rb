control 'V-219264' do
  title "The Ubuntu operating system must generate audit records for
successful/unsuccessful uses of the sudoedit command."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operating system generates an audit record when
successful/unsuccessful attempts to use the \"sudoedit\" command occur.

    Check the configured audit rules with the following commands:

    # sudo auditctl -l | grep /usr/bin/sudoedit

    -a always,exit -F path=/usr/bin/sudoedit -F perm=x -F auid>=1000 -F
auid!=-1 -k priv_cmd

    If the command does not return a line that matches the example or the line
is commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc 'fix', "
    Configure the audit system to generate an audit event for any
successful/unsuccessful use of the \"sudoedit\" command.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\":

    -a always,exit -F path=/usr/bin/sudoedit -F perm=x -F auid>=1000 -F
auid!=4294967295 -k priv_cmd

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag gid: 'V-219264'
  tag rid: 'SV-219264r508662_rule'
  tag stig_id: 'UBTU-18-010341'
  tag fix_id: 'F-20988r305121_fix'
  tag cci: ['SV-109857', 'V-100753', 'CCI-000172']
  tag nist: ['AU-12 c']

  audit_file = '/usr/bin/sudoedit'

  if file(audit_file).exist?
    impact 0.5
  else
    impact 0.0
  end

  if file(audit_file).exist?
    describe auditd.file(audit_file) do
      its('permissions') { should include ['x'] }
      its('action.uniq') { should eq ['always'] }
      its('list.uniq') { should eq ['exit'] }
    end
  end

  unless file(audit_file).exist?
    describe "The #{audit_file} file does not exist" do
      skip "The #{audit_file} file does not exist, this requirement is Not Applicable."
    end
  end
end
