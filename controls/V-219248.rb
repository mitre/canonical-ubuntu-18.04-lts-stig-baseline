control 'V-219248' do
  title "The Ubuntu operating system must generate audit records for any usage
of the lremovexattr system call."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).
  "
  desc  'rationale', ''
  desc  'check', "
    Verify if the Ubuntu operating system is configured to audit the execution
of the \"lremovexattr\" system call.

    Check the currently configured audit rules with the following command:

    # sudo auditctl -l | lremovexattr

    -a always,exit -F arch=b32 -S lremovexattr -F auid>=1000 -F auid!=-1 -k
perm_mod
    -a always,exit -F arch=b32 -S lremovexattr -F auid=0 -k perm_mod
    -a always,exit -F arch=b64 -S lremovexattr -F auid>=1000 -F auid!=-1 -k
perm_mod
    -a always,exit -F arch=b64 -S lremovexattr -F auid=0 -k perm_mod

    If the command does not return lines that match the example or the lines
are commented out, this is a finding.

    Notes:
    For 32-bit architectures, only the 32-bit specific output lines from the
commands are required.
    The '-k' allows for specifying an arbitrary identifier and the string after
it does not need to match the example output above.
  "
  desc 'fix', "
    Configure the audit system to generate an audit event for any
successful/unsuccessful use of the \"lremovexattr\" system call.

    Add or update the following rules in the \"/etc/audit/rules.d/stig.rules\"
file:

    -a always,exit -F arch=b32 -S lremovexattr -F auid>=1000 -F
auid!=4294967295 -k perm_mod
    -a always,exit -F arch=b32 -S lremovexattr -F auid=0 -k perm_mod
    -a always,exit -F arch=b64 -S lremovexattr -F auid>=1000 -F
auid!=4294967295 -k perm_mod
    -a always,exit -F arch=b64 -S lremovexattr -F auid=0 -k perm_mod

    Notes: For 32-bit architectures, only the 32-bit specific entries are
required.
    The \"root\" account must be used to view/edit any files in the
/etc/audit/rules.d/ directory.

    In order to reload the rules file, issue the following command:

    # sudo augenrules --load
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000064-GPOS-00033'
  tag gid: 'V-219248'
  tag rid: 'SV-219248r508662_rule'
  tag stig_id: 'UBTU-18-010325'
  tag fix_id: 'F-20972r305073_fix'
  tag cci: ['V-100721', 'SV-109825', 'CCI-000172']
  tag nist: ['AU-12 c']

  if os.arch.match?(/64/)
    describe auditd.syscall('lremovexattr').where { arch == 'b64' } do
      its('action.uniq') { should eq ['always'] }
      its('list.uniq') { should eq ['exit'] }
    end
  end
  describe auditd.syscall('lremovexattr').where { arch == 'b32' } do
    its('action.uniq') { should eq ['always'] }
    its('list.uniq') { should eq ['exit'] }
  end
end
