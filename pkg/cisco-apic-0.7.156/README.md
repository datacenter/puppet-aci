# Cisco APIC Puppet Module
## Overview
This module enables configuration of the Cisco ACI fabric via the Puppet configuration management system. By converting puppet manifests into APIC northbound REST API calls, this module can configure any features available via the APIC GUI, to achieve the desired end state.
## Dependencies
This module depends on the acirb ruby GEM, which is included in the gems directory, but is also available from http://github.com/datacenter/acirb. You will first need to install the ACIrb gem, using:
    gem install acirb-version.gem

Note that this package supports Ruby 1.9. Please ensure that whatever version of ruby puppet is utilizing is the same version of gem used to install the ACIrb gem
## Deployment
Given that APIC is a network device, this module is implemented using the **puppet device** framework, meaning that a puppet agent is not run directly on the controller, but rather a intermediary device will proxy between a puppet master and the target device.

You'll need the following components in order to use this module:
- Puppet master
- Proxy device (this can run on the master if needed)
- Configuration manifest
- Device configuration
- ACI controller

A sample manifest is provided in the manifests folder, and a sample device.conf is provided in the root folder. Once you have updated these to match your environment, you can use **puppetmaster.sh** to start up a  puppetmaster, and then invoke **puppetdevice.sh** to run the module and apply the configuration. Note that both of these have heavy debug enabled by default, so you may want to remove the "--debug" and "--trace" flags, unless you're debugging or just interested in the output.

## Manifests
Manifests are simple to write, as you can take an existing deployed configuration from an APIC, save it as XML or JSON and just substitute the payload into the config parameter.