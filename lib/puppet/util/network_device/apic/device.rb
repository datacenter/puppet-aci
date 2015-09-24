require 'acirb'
require 'puppet'
require 'puppet/util'
require 'puppet/util/network_device/apic'
require 'uri'

class Puppet::Util::NetworkDevice::Apic::Device
  attr_accessor :url, :rest

  def initialize(url, _options = {})
    @url = URI.parse(url)
    apicuri = '%s://%s' % [@url.scheme, @url.host]
    user = @url.user
    password = @url.password
    @rest = ACIrb::RestClient.new(url: apicuri, user: user,
                                      password: password)
  end

  def facts
    {}
  end
end
