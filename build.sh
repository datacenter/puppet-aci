#!/bin/bash

# this is the main puppet binary
PUPPET_PATH=/opt/puppetlabs/bin/puppet

# this is the path for puppet's bundled ruby, gem, etc. utils
PUPPET_UTILS_PATH=/opt/puppetlabs/puppet/bin

version=$(${PUPPET_UTILS_PATH}/ruby -e 'require "acirb"; puts ACIrb::VERSION'|sed -e 's/\([0-9]\+\.[0-9]\+\).*/\1/' )
echo "Using ACIrb Gem version $version"

# increment build number
set +e
test -e .build
if [ $? -eq 1 ] ; then
	echo 0 > .build
fi
build=$(cat .build)
build=$((build+1))
echo $build > .build

# insert new version into Modulefile
# sed -e "s/\$VERSION/$version.$build/g" < Modulefile.tmpl > Modulefile
sed -e "s/\$VERSION/$version.$build/g" < metadata.json.tmpl > metadata.json

FAILED=0
${PUPPET_PATH} module build --verbose || FAILED=1
if [ $FAILED -ne 0 ] ; then
	echo "Puppet module build did not complete successfully. Printing trace"
	${PUPPET_PATH} module build --trace
	exit 1
fi
${PUPPET_PATH} module uninstall puppet-aci || true
${PUPPET_PATH} module install -f pkg/puppet-aci-$version.$build.tar.gz

