# encoding: UTF-8

control 'V-219152' do
  title "The Ubuntu operating system must immediately notify the SA and ISSO
(at a minimum) when allocated audit record storage volume reaches 75% of the
repository maximum audit record storage capacity."
  desc  "If security personnel are not notified immediately when storage volume
reaches 75% utilization, they are unable to plan for audit record storage
capacity expansion."
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operating system notifies the System Administrator (SA)
and Information System Security Officer (ISSO) (at a minimum) when allocated
audit record storage volume reaches 75% of the repository maximum audit record
storage capacity.

    Check that the Ubuntu operating system notifies the SA and ISSO (at a
minimum) when allocated audit record storage volume reaches 75% of the
repository maximum audit record storage capacity with the following command:

    # sudo grep ^space_left_action /etc/audit/auditd.conf

    space_left_action email

    # sudo grep ^space_left /etc/audit/auditd.conf

    space_left 250000

    If the \"space_left\" parameter is missing, set to blanks or set to a value
less than 25% of the space free in the allocated audit record storage, this is
a finding.

    If the \"space_left_action\" parameter is missing or set to blanks, this is
a finding.

    If the \"space_left_action\" is set to \"syslog\", the system logs the
event, but does not generate a notification, so this is a finding.

    If the \"space_left_action\" is set to \"exec\", the system executes a
designated script. If this script informs the SA of the event, this is not a
finding.

    If the \"space_left_action\" is set to \"email\" check the value of the
\"action_mail_acct\" parameter with the following command:

    # sudo grep action_mail_acct /etc/audit/auditd.conf

    action_mail_acct root@localhost

    The \"action_mail_acct\" parameter, if missing, defaults to \"root\". If
the \"action_mail_acct parameter\" is not set to the e-mail address of the
system administrator(s) and/or ISSO, this is a finding.

    Note: If the email address of the system administrator is on a remote
system a mail package must be available.
  "
  desc  'fix', "
    Edit /etc/audit/auditd.conf and set the space_left_action parameter to
\"exec\" or \"email\".

    If the space_left_action parameter is set to \"email\" set the
action_mail_acct parameter to an e-mail address for the System Administrator
(SA) and Information System Security Officer (ISSO).

    If the space_left_action parameter is set to \"exec\", make sure the
command being execute notifies the System Administrator (SA) and Information
System Security Officer (ISSO).

    Edit /etc/audit/auditd.conf and set the space_left parameter to be, at
least, 25% of the repository maximum audit record storage capacity.
  "
  impact 0.3
  tag severity: 'low'
  tag gtitle: 'SRG-OS-000343-GPOS-00134'
  tag gid: 'V-219152'
  tag rid: 'SV-219152r508662_rule'
  tag stig_id: 'UBTU-18-010006'
  tag fix_id: 'F-20876r304785_fix'
  tag cci: ['SV-109633', 'V-100529', 'CCI-001855']
  tag nist: ['AU-5 (1)']

  describe auditd_conf do
    its('space_left_action') { should eq 'email' }
  end
  if((f = file(audit_log_dir = command("dirname #{auditd_conf.log_file}").stdout.strip)).directory?)
    # Fetch partition sizes in 1K blocks for consistency
    partition_info = command("df -B 1K #{audit_log_dir}").stdout.split("\n")
    partition_sz_arr = partition_info.last.gsub(/\s+/m, ' ').strip.split(" ")

    # Get partition size
    partition_sz = partition_sz_arr[1]

    # Convert to MB and get 25%
    exp_space_left = partition_sz.to_i / 1024 / 4

    describe auditd_conf do
      its('space_left.to_i') { should be >= exp_space_left }
    end
  else
    describe f.directory? do
     it { should be true }
    end
  end
end

