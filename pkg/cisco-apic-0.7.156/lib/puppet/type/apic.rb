Puppet::Type.newtype(:apic) do
  @doc = 'An APIC that will be accessed'

  ensurable
  apply_to_device

  newparam(:apicname, namevar: true) do
    desc 'Name of the APIC'
  end

  newparam(:address) do
    desc 'URL for APIC'
  end

  newparam(:config_type) do
    desc 'Configuration type for config (xml, json or hash)'
  end

  newparam(:config) do
    desc 'Configuration defined as JSON, XML or Ruby Hash, as' \
         ' specified by config_type'
  end

  newparam(:user) do
    defaultto('admin')
    desc 'APIC Username'
  end

  newparam(:password) do
    desc 'APIC Password'
  end
end
