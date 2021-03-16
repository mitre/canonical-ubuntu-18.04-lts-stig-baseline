# encoding: UTF-8

control 'V-219303' do
  title "The Ubuntu operating system must initiate a session lock after a
15-minute period of inactivity for all connection types."
  desc  "A session time-out lock is a temporary action taken when a user stops
work and moves away from the immediate physical vicinity of the information
system but does not log out because of the temporary nature of the absence.
Rather than relying on the user to manually lock their operating system session
prior to vacating the vicinity, the Ubuntu operating system need to be able to
identify when a user's session has idled and take action to initiate the
session lock.

    The session lock is implemented at the point where session activity can be
determined and/or controlled.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the Ubuntu operating system initiates a session logout after a
15-minute period of inactivity.

    Check that the proper auto logout script exists with the following command:

    # cat /etc/profile.d/autologout.sh
    TMOUT=900
    readonly TMOUT
    export TMOUT

    If the file \"/etc/profile.d/autologout.sh\" does not exist with the
contents shown above, the value of \"TMOUT\" is greater than 900, or the
timeout values are commented out, this is a finding.
  "
  desc  'fix', "
    Configure the Ubuntu operating system to initiate a session logout after a
15-minute period of inactivity.

    Create a file to contain the system-wide session auto logout script (if it
does not already exist) with the following command:

    # sudo touch /etc/profile.d/autologout.sh

    Add the following lines to the \"/etc/profile.d/autologout.sh\" script:

    TMOUT=900
    readonly TMOUT
    export TMOUT
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000029-GPOS-00010'
  tag gid: 'V-219303'
  tag rid: 'SV-219303r508662_rule'
  tag stig_id: 'UBTU-18-010402'
  tag fix_id: 'F-21027r305238_fix'
  tag cci: ['V-100829', 'SV-109933', 'CCI-000057']
  tag nist: ['AC-11 a']

  # Check if TMOUT is set in files (passive test)
  files = ['/etc/bashrc'] + ['/etc/profile'] + command("find /etc/profile.d/*").stdout.split("\n")
  latest_val = nil

  files.each do |file|
    readonly = false

    # Skip to next file if TMOUT isn't present. Otherwise, get the last occurrence of TMOUT
    next if (values = command("grep -Po '.*TMOUT.*' #{file}").stdout.split("\n")).empty?

    # Loop through each TMOUT match and see if set TMOUT's value or makes it readonly
    values.each_with_index { |value, index|

      # Skip if starts with '#' - it represents a comment
      next if !value.match(/^#/).nil?
      # If readonly and value is inline - use that value
      if !value.match(/^readonly[\s]+TMOUT[\s]*=[\s]*[\d]+$/).nil?
        latest_val = value.match(/[\d]+/)[0].to_i
        readonly = true
        break
      # If readonly, but, value is not inline - use the most recent value
      elsif !value.match(/^readonly[\s]+([\w]+[\s]+)?TMOUT[\s]*([\s]+[\w]+[\s]*)*$/).nil?
        # If the index is greater than 0, the configuraiton setting value.
        # Otherwise, the configuration setting value is in the previous file
        # and is already set in latest_val.
        if index >= 1
          latest_val = values[index - 1].match(/[\d]+/)[0].to_i
        end
        readonly = true
        break
      # Readonly is not set use the lastest value
      else
        latest_val = value.match(/[\d]+/)[0].to_i
      end
    }
    # Readonly is set - stop processing files
    break if readonly === true
  end

  if latest_val.nil?
    describe "The TMOUT setting is configured" do
      subject { !latest_val.nil? }
      it { should be true }
    end
  else
    describe"The TMOUT setting is configured properly" do
      subject { latest_val }
      it { should cmp <= input('system_activity_timeout')}
    end
  end  
end
