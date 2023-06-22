MariaDB Columnstore (MCS) has two types of testing suites:

- unit tests located in `columnstore/tests` using the testing framework `[googletest](https://github.com/google/googletest)`
- regression tests located in `columnstore/mysql-test/columnstore` which can be run using the `[mysql-test-run.pl](https://man7.org/linux/man-pages/man1/mysql-test-run.pl.1.html)` script or `mtr` for short.

## Unit Tests

tbw

## Regression Tests

```bash
cp -r mysql-test/columnstore /usr/share/mysql-test/suite/
echo character_set_server=latin1 >> /etc/my.cnf.d/columnstore.cnf
echo collation_server=latin1_swedish_ci >> /etc/my.cnf.d/columnstore.cnf

systemctl daemon-reload
systemctl start mariadb
mariadb -e "create database if not exists test;"
systemctl restart mariadb-columnstore
cd /usr/share/mysql-test
./mtr --extern socket=/var/lib/mysql/mysql.sock --force --print-core=detailed --print-method=gdb --max-test-fail=0 --suite=columnstore/bugfixes

```

About mtr: ******???******

At the moment `mtr` can’t bootstrap MariaDB with ColumnStore support. Therefore you have to pre-setup MDB with the MCS plugin and provide `mtr` with an external socket which serves as the connection point to the running MDB service with MCS as its storage engine.

You can register MDB as a service and bootstrap it with ColumnStore using the `build/bootstrap_mcs.h` script. If you haven’t done so already run in the `columnstore/columnstore` directory:

```bash
sudo -E build/bootstrap_mcs.h
```

You also need to install the `mysql-test-suite` on your machine: **???**

Assuming the the `mysql-test` suite is installed in `/usr/share/mysql-test/` you can proceed to copy the columnstore test suite into the `suite` directory of `mysql-test` via:

```bash
cd server/storage/columnstore/columnstore
cp -r mysql-test/columnstore /usr/share/mysql-test/suite/
```

(starting from the home directory of columnstore)

Optionally, make sure that the mariadb and mariadb-columnstore services are running and create a test database:

```bash
systemctl daemon-reload
systemctl start mariadb
mariadb -e "create database if not exists test;"
systemctl restart mariadb-columnstore
```

You can then run the mtr

```bash
cd /usr/share/mysql-test
./mtr --extern socket=/var/lib/mysql/mysql.sock --force --print-core=detailed --print-method=gdb --max-test-fail=0 --suite=columnstore/<suite> <single_test_name>

```

produce a golden file automatically like this.

`cd /server_root/mysql-test
./mtr --record --extern socket=/run/mysqld/mysqld.sock  --suite=columnstore/bugfixes test_name`

You can run a single test similar to this

`cd /server_root/mysql-test
./mtr --extern socket=/run/mysqld/mysqld.sock  --suite=columnstore/bugfixes test_name`

The golden file goes into mysql-test/columnstore/basic/r/test_name.result.

The existing MTR infrastructure will pick up the MTR tests from Columnstore storage engine folder.