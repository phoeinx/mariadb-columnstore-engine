#!/usr/bin/env bash

set -xeuo pipefail

VERSION=$1
RESULT=$2
UPGRADE_TOKEN=$3

sed -i "s/exit 101/exit 0/g" /usr/sbin/policy-rc.d
bash -c "apt update --yes && apt install -y procps wget curl"
wget https://dlm.mariadb.com/enterprise-release-helpers/mariadb_es_repo_setup -O mariadb_es_repo_setup
chmod +x mariadb_es_repo_setup
bash -c "./mariadb_es_repo_setup --token=${UPGRADE_TOKEN} --apply --mariadb-server-version=${VERSION} --skip-maxscale --skip-tools"
apt update --yes
apt install --yes mariadb-server mariadb-client mariadb-plugin-columnstore
systemctl start mariadb
systemctl start mariadb-columnstore
bash -c "./upgrade_data.sh"
bash -c "./upgrade_verify.sh"

touch /etc/apt/auth.conf
cat << EOF > /etc/apt/auth.conf
machine https://cspkg.s3.amazonaws.com/develop/cron/7689/10.6-enterprise/amd64/${RESULT}/
EOF

apt update --yes
apt install -y ca-certificates
cd /etc/apt/sources.list.d
echo "deb [trusted=yes] https://cspkg.s3.amazonaws.com/develop/cron/7476/10.6-enterprise/amd64/${RESULT}/" > repo.list

apt update --yes
bash -c "./upgrade_verify.sh"
