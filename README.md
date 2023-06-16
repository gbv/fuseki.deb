# Fuseki Debian package

This repository contains a script to generate a Debian package of [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) RDF Triple store with SPARQL API and user interface. This Debian package is not affiliated with the Apache project. See <https://github.com/apache/jena> for Fuseki sources.

## Overview

Fuseki is run as dedicated system user `fuseki`. Directory layout is same as in [Skosmos installation instructions](https://github.com/NatLibFi/Skosmos/wiki/InstallTutorial):

- Fuseki code is in `/opt/fuseki`
- [Configuration](#configuration) is in `/etc/fuseki` 
- Logging (if enabled) is in `/var/log/fuseki`
- Databases are `/var/lib/fuseki`

## Installation

Download package from <https://github.com/gbv/fuseki.deb/releases> and install:

    sudo dpkg --install ./fuseki_4.8.0-1_all.deb && sudo apt install -f

After installation, the service must be enabled to start on boot:

    sudo systemctl enable fuseki

The service must be restarted once to create missing configuration files in `/etc/fuseki`

    sudo systemctl restart fuseki

To deinstall the application (excluding configuration and databases):

    sudo dpkg --remove fuseki

To further remove configuration files (excluding databases):

    sudo dpkg --purge fuseki

You may further want to add `/opt/fuseki/bin` to your `$PATH` to facilitate use of client scripts.

## Configuration

Startup options can be configured in `/etc/systemd/system/fuseki.service`. In particular this includes:

- the amount of memory allocated to Fuseki (4 GB by default)
- whether logs should be written to the logging directory (journalctl is used by default, run `journalctl -u fuseki` to inspect)
- when to restart the service (`on-failure` by default)

See [Fuseki documentation](https://jena.apache.org/documentation/fuseki2/fuseki-configuration.html) for additional configuration.

Access control can be configured in both `/etc/fuseki/config.ttl` and in `/etc/fuseki/shiro.ini`.

Individual databases can be configured in `/etc/fuseki/configuration/` with one file per database.

The user interface, installed at `/opt/fuseki/webapp` can be cloning, modifying and compiling it's [source code](https://github.com/apache/jena/tree/main/jena-fuseki2/jena-fuseki-ui) and then overwrite the existing web application:

~~~sh
npm run build
sudo rm -rf /opt/fuseki/webapp
sudo cp -r target/webapp /opt/fuseki/webapp
sudo chown -R fuseki:fuseki /opt/fuseki/webapp
~~~

## Usage

Fuseki runs on port 3030 by default. The server can be monitored and controlled via [Fuseki HTTP Administration Protocol], in particular creation of databases. Data can be loaded into and retrieved from existing databases via SPARQL endpoints (Query, Update, and Graph Store Protocol) and by direct access to the underlying [TBD databases](https://jena.apache.org/documentation/tdb/).

### Clients

Fuseki includes two clients:

- user interface, made available at <http://localhost:3030/>
- [client scripts](https://jena.apache.org/documentation/fuseki2/soh.html) in `/opt/fuseki/bin` (require ruby to be installed)

Direct access to existing TDB databases is further possible via [TBD command line tools](https://jena.apache.org/documentation/tdb2/tdb2_cmds.html) and recommended to import very large datasets. These commands can be executed like this:

~~~sh
java -cp /opt/fuseki/fuseki-server.jar tdb2.tdbloader --help
~~~

[Fuseki HTTP Administration Protocol]: https://jena.apache.org/documentation/fuseki2/fuseki-server-protocol.html

### Getting started

Access to parts of [Fuseki HTTP Administration Protocol] is restricted to localhost by default, so new databases can only be created locally, via user interface or from command line like this:

~~~sh
curl --data "dbName=test&dbType=tdb2" http://localhost:3030/$/datasets
~~~

Uploading or editing data via SPARQL from/to existing databases is *not* restricted by default!

## See also

The [Apache Jena binary release](https://jena.apache.org/download/) includes several useful [command line tools](https://jena.apache.org/documentation/tools/index.html) for processing RDF.

The Debian package `libapache-jena-java` installs [Apache Jena](https://jena.apache.org/) libraries, not including Fuseki nor the command line tools.

## Alternatives

You may want to try [Fuseki Docker](https://jena.apache.org/documentation/fuseki2/fuseki-docker.html).

## How this package is build

Script `build.sh` executed with a version number downloads Fuseki release and builds a corresponding Debian package.

## License

Fuseki and this Debian package is made available under Apache License.
