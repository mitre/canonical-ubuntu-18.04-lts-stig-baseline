control 'V-219243' do
  title "The Ubuntu operating system must generate audit records for
successful/unsuccessful uses of the ssh-keysign command."
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
successful/unsuccessful attempts to use the \"ssh-keysign\" command occur.

    Check the configured audit rules with the following commands:

    #sudo auditctl -l | grep ssh-keysign

    -a always,exit -F path=/usr/lib/openssh/ssh-keysign -F perm=x -F auid>=1000
-F auid!=-1 -k privileged-ssh

    If the command does not return lines that match the example or the lines
are commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc 'fix', "
    Configure the audit system to generate an audit event for any
successful/unsuccessful use of the \"ssh-keysign\" command.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -a always,exit -F path=/usr/lib/openssh/ssh-keysign -F perm=x -F auid>=1000
-F auid!=4294967295 -k privileged-ssh

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag gid: 'V-219243'
  tag rid: 'SV-219243r508662_rule'
  tag stig_id: 'UBTU-18-010320'
  tag fix_id: 'F-20967r305058_fix'
  tag cci: ['SV-109817', 'V-100713', 'CCI-000172']
  tag nist: ['AU-12 c']

  audit_file = '/usr/lib/openssh/ssh-keysign'

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
