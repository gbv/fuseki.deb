#!/usr/bin/bash

if [[ ! "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+-[0-9]+$ ]]; then
    echo "Expecting version argument such as 4.8.0-1"
    exit 1
fi

IFS='-' read version revision <<< "$1"

name=fuseki
arch=all
maintainer="Jakob Voß <jakob.voss@gbv.de>"
depends=default-jre-headless

package="${name}_${version}-${revision}_${arch}"

fuseki=apache-jena-fuseki-$version
if [ ! -f "$fuseki.tar.gz" ]; then
    echo "Downloading fuseki $version"
    wget --no-verbose "https://repository.apache.org/content/repositories/releases/org/apache/jena/apache-jena-fuseki/$version/$fuseki.tar.gz"
fi

rm -rf "$package"

mkdir -p "$package/opt"
tar -zxf "$fuseki.tar.gz"
mv "$fuseki" "$package/opt/fuseki"

mkdir -p "$package/DEBIAN"

cat <<-EOF > "$package/DEBIAN/control"
Package: $name
Version: $version
Architecture: $arch
Maintainer: $maintainer
Description: Jena Fuseki with user interface
Homepage: https://jena.apache.org/documentation/fuseki2/
Depends: $depends
EOF

cat <<-EOF > "$package/DEBIAN/copyright"
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: Apache Jena Fuseki
Source: https://jena.apache.org/download/
Files: *
License: Apache
EOF

cp postinst "$package/DEBIAN"
cp {pre,post}rm "$package/DEBIAN"

# See /opt/fuseki/fuseki.service for official service file
mkdir -p "$package/etc/systemd/system"
cp fuseki.service "$package/etc/systemd/system"

dpkg-deb --build --root-owner-group "$package"
