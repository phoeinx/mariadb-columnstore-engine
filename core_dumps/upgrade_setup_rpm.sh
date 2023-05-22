#!/usr/bin/env bash

set -xeuo pipefail

VERSION="$1"
RESULT="$2"
ARCH="$3"
UPGRADE_TOKEN="$4"

dnf install -y wget which procps-ng
yum install -y diffutils
wget https://dlm.mariadb.com/enterprise-release-helpers/mariadb_es_repo_setup -O mariadb_es_repo_setup
chmod +x mariadb_es_repo_setup
bash -c "./mariadb_es_repo_setup --token=${UPGRADE_TOKEN} --apply --mariadb-server-version=${VERSION} --skip-maxscale --skip-tools"
dnf repo-pkgs mariadb-es-main list
dnf -y install MariaDB-server MariaDB-client MariaDB-columnstore-engine MariaDB-columnstore-engine-debuginfo

systemctl start mariadb
systemctl start mariadb-columnstore
bash -c "./upgrade_data.sh"
bash -c "./upgrade_verify.sh"

touch /etc/dnf.repos.d/repo.repo
cat <<EOF > /etc/dnf.repos.d/repo.repo
[repo]
name = repo
baseurl = https://cspkg.s3.amazonaws.com/develop/latest/10.6-enterprise/${ARCH}/${RESULT}/
enabled = 1
gpgcheck = 0
module_hotfixes=1
EOF

dnf repo-pkgs repo list
dnf -y update MariaDB-server MariaDB-client MariaDB-columnstore-engine MariaDB-columnstore-engine-debuginfo
bash -c "./upgrade_verify.sh"
