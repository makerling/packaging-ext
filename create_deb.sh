#! /bin/bash

# options: 1.4.1,1.3.3,1.3.2,1.3.1,1.3.0,1.2.0,1.1.3,1.1.2,1.1.1,1.1.0,1.0.2,1.0.1,1.0.0
pg_jobmon_version='1.4.1'
# options: 9.2,9.3,9.4,9.5,9.6,10,11,12,13,14
pg_version='13'
deb_rpm_version='1.0.0'

# download and unpack source of the postgres extension
wget https://github.com/omniti-labs/pg_jobmon/archive/refs/tags/v"$pg_jobmon_version".tar.gz
filename=$(ls *.tar.gz)
tar xvzf "$filename"
folder=$(ls -d */)
foldername=${folder:0:-1}

# # install postgres and build tools
# sudo apt install curl ca-certificates gnupg
# curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# sudo apt update && sudo apt -y install postgresql-"$pg_version"
# sudo apt update && sudo apt install build-essential libicu-dev \
#     postgresql-server-dev-"$pg_version" -y --no-install-recommends

# build extension from source
cd "$foldername"
# mkdir install
make && make install DESTDIR=./install

# package artifact as deb
mkdir ./DEBIAN/
printf "Package: postgresql-"$pg_version"-pg-jobmon\n\
Version: "$deb_rpm_version"\n\
Section: database\n\
Priority: optional\n\
Architecture: amd64\n\
Depends: postgresql-"$pg_version"\n\
Maintainer: Stevan Vanderwerf <github@vanderling.com>\n\
Description: pg_jobmon is a PostgreSQL extension designed to add autonomous \n\
    logging capabilities to transactions and functions. The logging is done in a \n\
    NON-TRANSACTIONAL method, so that if your function/transaction fails for any reason, \n\
    any information written to that point will be kept in the log tables rather than \n\
    rolled back.\n" > ./DEBIAN/control

cd .. 
sudo dpkg-deb --build "$foldername"

echo "starting rpm packaging"

# sudo apt-get update && sudo apt-get install ruby ruby-dev rubygems gcc make rpm
# sudo gem install --no-document fpm
fpm --input-type dir --output-type rpm  \
    --version "$pg_jobmon_version" \
    --package pg_jobmon-"$pg_jobmon_version".rpm \
    --depends "rh-postgresql"$pg_version"-postgresql" \
    --name pg_jobmon-"$pg_jobmon_version" \
    "$foldername"/install
ls
echo "finished successfully"