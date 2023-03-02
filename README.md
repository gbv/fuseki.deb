# Fuseki Debian package

This repository contains a script to generate a Debian package of Apache Jena Fuseki RDF Triple store with user interface.

The directory layout is aligned with [Skosmos installation instructions](https://github.com/NatLibFi/Skosmos/wiki/InstallTutorial):

- Fuseki code is in `/opt/fuseki`
- Configuration is in `/etc/fuseki`
- Logging (if enabled) is in `/var/log/fuseki`
- Databases are `/var/lib/fuseki`

After installation, the service must be enabled to start on boot:

    sudo dpkg --install ./fuseki_4.7.0-1_all.deb
    sudo systemctl start fuseki

Memory and other startup options can be configured in `/etc/systemd/system/fuseki.service`.
