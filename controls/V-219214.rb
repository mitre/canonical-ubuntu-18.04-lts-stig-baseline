control 'V-219214' do
  title "The Ubuntu operating system must generate audit records for the use
and modification of faillog file."
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
successful/unsuccessful modifications to the \"faillog\" file occur.

    Check the currently configured audit rules with the following command:

    # sudo auditctl -l | grep faillog

    -w /var/log/faillog -p wa -k logins

    If the command does not return a line that matches the example or the line
is commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc 'fix', "
    Configure the audit system to generate an audit event for any
successful/unsuccessful modifications to the \"faillog\" file occur.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -w /var/log/faillog -p wa -k logins

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag satisfies: ['SRG-OS-000064-GPOS-00033', 'SRG-OS-000470-GPOS-00214',
                  'SRG-OS-000473-GPOS-00218']
  tag gid: 'V-219214'
  tag rid: 'SV-219214r508662_rule'
  tag stig_id: 'UBTU-18-010202'
  tag fix_id: 'F-20938r304971_fix'
  tag cci: ['V-100655', 'SV-109759', 'CCI-000172']
  tag nist: ['AU-12 c']

  audit_file = '/var/log/faillog'

  if file(audit_file).exist?
    impact 0.5
  else
    impact 0.0
  end

  if file(audit_file).exist?
    describe auditd.file(audit_file) do
      its('permissions') { should include ['w'] }
      its('permissions') { should include ['a'] }
      its('action') { should_not include 'never' }
    end
  end

  unless file(audit_file).exist?
    describe "The #{audit_file} file does not exist" do
      skip "The #{audit_file} file does not exist, this requirement is Not Applicable."
    end
  end
end
