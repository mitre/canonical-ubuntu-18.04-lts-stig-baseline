control 'V-219325' do
  title 'The Ubuntu operating system must uniquely identify interactive users.'
  desc  "To assure accountability and prevent unauthenticated access,
organizational users must be identified and authenticated to prevent potential
misuse and compromise of the system.

    Organizational users include organizational employees or individuals the
organization deems to have equivalent status of employees (e.g., contractors).
Organizational users (and processes acting on behalf of users) must be uniquely
identified and authenticated to all accesses, except for the following:

    1) Accesses explicitly identified and documented by the organization.
Organizations document specific user actions that can be performed on the
information system without identification or authentication; and

    2) Accesses that occur through authorized use of group authenticators
without individual authentication. Organizations may require unique
identification of individuals in group accounts (e.g., shared privilege
accounts) or for detailed accountability of individual activity.


  "
  desc  'rationale', ''
  desc  'check', "
    Verify that the Ubuntu operating system contains no duplicate User IDs
(UIDs) for interactive users.

    Check that the Ubuntu operating system contains no duplicate UIDs for
interactive users with the following command:

    # awk -F \":\" 'list[$3]++{print $1, $3}' /etc/passwd

    If output is produced, and the accounts listed are interactive user
accounts, this is a finding.
  "
  desc  'fix', "Edit the file \"/etc/passwd\" and provide each interactive user
account that has a duplicate User ID (UID) with a unique UID."
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000104-GPOS-00051'
  tag satisfies: ['SRG-OS-000104-GPOS-00051', 'SRG-OS-000121-GPOS-00062']
  tag gid: 'V-219325'
  tag rid: 'SV-219325r508662_rule'
  tag stig_id: 'UBTU-18-010444'
  tag fix_id: 'F-21049r305304_fix'
  tag cci: ['SV-109977', 'V-100873', 'CCI-000764', 'CCI-000804']
  tag nist: ['IA-2', 'IA-8']
end
