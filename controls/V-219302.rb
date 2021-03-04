# encoding: UTF-8

control 'V-219302' do
  title "The Ubuntu operating system must retain a users session lock until
that user reestablishes access using established identification and
authentication procedures."
  desc  "A session lock is a temporary action taken when a user stops work and
moves away from the immediate physical vicinity of the information system but
does not want to log out because of the temporary nature of the absence.

    The session lock is implemented at the point where session activity can be
determined. Rather than be forced to wait for a period of time to expire before
the user session can be locked, Ubuntu operating systems need to provide users
with the ability to manually invoke a session lock so users may secure their
session should the need arise for them to temporarily vacate the immediate
physical vicinity.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operation system has a graphical user interface session
lock enabled.

    Note: If the Ubuntu operating system does not have a Graphical User
Interface installed, this requirement is Not Applicable.

    Get the \"\"lock-enabled\"\" setting to verify if the graphical user
interface session has the lock enabled with the following command:

    # sudo gsettings get org.gnome.desktop.screensaver lock-enabled

    true

    If \"lock-enabled\" is not set to \"true\", this is a finding.
  "
  desc  'fix', "
    Configure the Ubuntu operating system so that it allows a user to lock the
current graphical user interface session.

    Note: If the Ubuntu operating system does not have a Graphical User
Interface installed, this requirement is Not Applicable.

    Set the \"\"lock-enabled\"\" setting to allow graphical user interface
session locks with the following command:

    # sudo gsettings set org.gnome.desktop.screensaver lock-enabled true
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000028-GPOS-00009'
  tag gid: 'V-219302'
  tag rid: 'SV-219302r508662_rule'
  tag stig_id: 'UBTU-18-010401'
  tag fix_id: 'F-21026r305235_fix'
  tag cci: ['V-100827', 'SV-109931', 'CCI-000056']
  tag nist: ['AC-11 b']

  if !package('gdm3').installed?
    impact 0.0
    describe "The GNOME Display Manager (GDM3) Package is not installed on the system" do
      skip "This control is Not Appliciable without the GNOME Display Manager (GDM3) Package installed."
    end
  else
    describe command("gsettings writable org.gnome.desktop.screensaver lock-enabled") do
    its('stdout.strip') { should cmp 'false' }
    end
  end
end

