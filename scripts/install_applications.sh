#!/bin/bash -eux

# Auto accept the terms for the install
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

# Add the repository
sudo add-apt-repository ppa:webupd8team/java

# Update repository
sudo apt-get update

# Install Oracle JRE and JDK
sudo apt-get install oracle-java8-installer

# Set up environment variables
sudo apt-get install oracle-java8-set-default

# Check the version
java -version

# Insntall postgresql
sudo apt-get install -y postgresql
