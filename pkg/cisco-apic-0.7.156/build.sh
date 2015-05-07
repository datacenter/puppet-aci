#!/bin/bash
version=$(ruby -e 'require "acirb"; puts ACIrb::VERSION')
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
sed -e "s/\$VERSION/$version.$build/g" < Modulefile.tmpl > Modulefile

FAILED=0
puppet module build --verbose || FAILED=1
if [ $FAILED -ne 0 ] ; then
	echo "Puppet module build did not complete successfully. Printing trace"
	puppet module build --trace
	exit 1
fi
puppet module uninstall cisco-apic || true
puppet module install -f pkg/cisco-apic-$version.$build.tar.gz

