#! /bin/bash

# download and unpack source of the postgres extension
wget https://github.com/omniti-labs/pg_jobmon/archive/refs/tags/v1.4.1.tar.gz
filename=$(ls *.tar.gz)
echo "$filename"
tar xvzf "$filename"
folder=$(ls -d */)
foldername=${folder:0:-1}
echo "$foldername"

# install postgres and build tools
sudo apt install curl ca-certificates gnupg
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update && sudo apt -y install postgresql-13
sudo apt update && sudo apt install build-essential libicu-dev \
    postgresql-server-dev-13 -y --no-install-recommends

# build extension from source
cd "$foldername"            
make && make install

# package artifact as deb
mkdir ./DEBIAN/
ls
pwd
printf "Package: postgresql-13-pg-jobmon\n\
Version: 1.0.0\n\
Section: database\n\
Priority: optional\n\
Architecture: amd64\n\
Depends: postgresql-13\n\
Maintainer: Stevan Vanderwerf <github@vanderling.com>\n\
Description: pg_jobmon is a PostgreSQL extension designed to add autonomous \n\
    logging capabilities to transactions and functions. The logging is done in a \n\
    NON-TRANSACTIONAL method, so that if your function/transaction fails for any reason, \n\
    any information written to that point will be kept in the log tables rather than \n\
    rolled back.\n" > ./DEBIAN/control

cd .. 
sudo dpkg-deb --build "$foldername"
echo "finished successfully"