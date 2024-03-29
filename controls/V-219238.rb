control 'V-219238' do
  title "The Ubuntu operating system must generate audit records for
successful/unsuccessful uses of the su command."
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
successful/unsuccessful attempts to use the \"su\" command occur.

    Check the configured audit rules with the following commands:

    # sudo auditctl -l | grep '/bin/su'

    -a always,exit -F path=/bin/su -F perm=x -F auid>=1000 -F auid!=-1 -k
privileged-priv_change

    If the command does not return lines that match the example or the lines
are commented out, this is a finding.

    Note: The '-k' allows for specifying an arbitrary identifier and the string
after it does not need to match the example output above.
  "
  desc 'fix', "
    Configure the Ubuntu operating system to generate audit records when
successful/unsuccessful attempts to use the \"su\" command occur.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -a always,exit -F path=/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295
-k privileged-priv_change

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load

    Note:
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag gid: 'V-219238'
  tag rid: 'SV-219238r508662_rule'
  tag stig_id: 'UBTU-18-010315'
  tag fix_id: 'F-20962r485694_fix'
  tag cci: ['V-100703', 'SV-109807', 'CCI-000172']
  tag nist: ['AU-12 c']

  # describe auditd.file('/etc/sudoers') do
  #  its('permissions') { should include ['x'] }
  # end

  describe auditd.file('/bin/su') do
    its('action.uniq') { should eq ['always'] }
    its('list.uniq') { should eq ['exit'] }
    its('permissions') { should include ['x'] }
  end
end
