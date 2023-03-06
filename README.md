# Fuseki Debian package

This repository contains a script to generate a Debian package of [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) RDF Triple store with SPARQL API and user interface. The Debian package is not affiliated with the Apache project.

## Overview

Fuseki is run as dedicated system user `fuseki`. Directory layout is same as in [Skosmos installation instructions](https://github.com/NatLibFi/Skosmos/wiki/InstallTutorial):

- Fuseki code is in `/opt/fuseki`
- [Configuration](#configuration) is in `/etc/fuseki` 
- Logging (if enabled) is in `/var/log/fuseki`
- Databases are `/var/lib/fuseki`

## Installation

Download package from <https://github.com/gbv/fuseki.deb/releases> and install:

    sudo dpkg --install ./fuseki_4.7.0-1_all.deb

After installation, the service must be enabled to start on boot:

    sudo systemctl enable fuseki

The service must be restarted once to create missing configuration files in `/etc/fuseki`

    sudo systemctl restart fuseki

To deinstall the application:

    sudo dpkg --remove fuseki

To further remove configuration files:

    sudo dpkg --purge fuseki

Database files in `/var/lib/fuseki` must be removed manually.

## Configuration

Startup options can be configured in `/etc/systemd/system/fuseki.service`. In particular this includes:

- the amount of memory allocated to Fuseki (4 GB by default)
- whether logs should be written to the logging directory (journalctl is used by default, run `journalctl -u fuseki` to inspect)
- when to restart the service (`on-failure` by default)

See [Fuseki documentation](https://jena.apache.org/documentation/fuseki2/fuseki-configuration.html) for additional configuration.

Access control can be configured in both `/etc/fuseki/config.ttl` and in `/etc/fuseki/shiro.ini`.

## Usage

Fuseki runs on port 3030 by default. A user interface is available at <http://localhost:3030/>.

There are some helper scripts in `/opt/fuseki/bin` (require ruby to be installed)

## See also

The [Apache Jena binary release](https://jena.apache.org/download/) includes several useful [command line tools](https://jena.apache.org/documentation/tools/index.html) for processing RDF.

The Debian package `libapache-jena-java` installs [Apache Jena](https://jena.apache.org/) libraries, not including Fuseki nor the command line tools.

## License

Fuseki and this Debian package is made available under Apache License.
