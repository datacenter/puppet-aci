require 'acirb'
require 'puppet'
require 'rexml/document'
require 'rubygems'

Puppet::Type.type(:apic).provide :apic do
  desc 'Manage APIC'

  def loadconfig(config_type, config)
    if config_type == 'xml'
      mo = ACIrb::Loader.load_xml_str(config)
    elsif config_type == 'json'
      mo = ACIrb::Loader.load_json_str(config)
    elsif config_type == 'hash'
      mo = ACIrb::Loader.load_hash(config)
    end
    mo
  end

  def restclient(url, user, password)
    begin
      device = Puppet::Util::NetworkDevice.current
    rescue
      device = nil
    end

    if device
      info('Using NetworkDevice rest')
      return device.rest
    else
      info('Establishing new REST session')
      return ACIrb::RestClient.new(url: url, user: user, password: password)
    end
  end

  def create
    info('Invoking %s' % __method__.to_s)

    url ||= @resource[:address] || @property_hash[:address]
    user ||= @resource[:user] || @property_hash[:user]
    password ||= @resource[:password] || @property_hash[:password]

    rest = restclient(url, user, password)

    mo = loadconfig(@resource[:config_type], @resource[:config])

    mocreate = mo.create(rest)
  end

  def destroy
    info('Invoking %s' % __method__.to_s)

    url ||= @resource[:address] || @property_hash[:address]
    user ||= @resource[:user] || @property_hash[:user]
    password ||= @resource[:password] || @property_hash[:password]

    rest = restclient(url, user, password)

    mo = loadconfig(@resource[:config_type], @resource[:config])

    mo.destroy(rest)
  end

  def exists?
    info('Invoking %s' % __method__.to_s)
    url ||= @resource[:address] || @property_hash[:address]
    user ||= @resource[:user] || @property_hash[:user]
    password ||= @resource[:password] || @property_hash[:password]

    rest = restclient(url, user, password)

    config_type ||= @resource[:config_type] || @property_hash[:config_type]
    config ||= @resource[:config] || @property_hash[:config]

    mo = loadconfig(config_type, config)

    moexists = mo.exists(rest, true)

    @property_hash[:address] = url

    moexists
  end

  def self.instances
    raise Puppet::DevError, "Provider #{self.name} has not defined the 'instances' class method"

    # Need more details on the specific use cases for this invocation
    info('Invoking %s' % __method__.to_s)

    syntaxString = 'The following environment variables must be defined
  APIC_DN: Distinguished name of the tree to query
  APIC_ROOT: Parent to tree to query
  APIC_ADDRESS: IP address of the controller
  APIC_USERNAME: Username for the APIC
  APIC_PASSWORD: Password for the APIC

These should be assigned using export or pre-pended to the puppet command, e.g.,

  export APIC_ADDRESS=10.0.0.1
  export APIC_USERNAME=admin
  export APIC_PASSWORD=cisco
  export APIC_DN=uni/tn-Cisco
  export APIC_ROOT=uni
  puppet resource apic
'

    required = %w(APIC_DN APIC_ROOT APIC_ADDRESS APIC_USERNAME APIC_PASSWORD)
    required.each do |key|
      fail(syntaxString) unless ENV.include?(key)
    end

    dn = ENV['APIC_DN']
    root = ENV['APIC_ROOT']
    url = ENV['APIC_ADDRESS']
    user = ENV['APIC_USERNAME']
    password = ENV['APIC_PASSWORD']

    rest = ACIrb::RestClient.new(url: url, user: user, password: password)

    debug('Looking up Dn ' + dn)
    mo = rest.lookupByDn(dn: dn, subtree: 'full')
    if mo
      debug(mo.to_s)

      Array(new(name: 'APIC',
                address: url,
                root: root,
                user: user,
                password: password,
                config_type: 'xml',
                config: mo.to_xml.to_s,
                ensure: :present
               ))
    else
      Array(new(name: 'APIC',
                address: url,
                root: root,
                user: user,
                password: password,
                config_type: 'xml',
                config: '<polUni/>',
                ensure: :present
               ))
    end
  end
end
