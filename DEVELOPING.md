## Logging

How to log in MCS:

```bash
std::cout << row.toString() << std::endl;
```

Stuff gets printed to journalctl, check with:

```bash
journalctl -u mariadb | tail
```

As mariadb runs as a system service / daemon its logs get collected by journalctl (which shows logs from the systemd journal). 

## Restarting services after a crash

Sometimes e.g. during debugging single processes can crash. 

To restart a mcs-specific unit process run:

```
systemctl restart mcs-<process_name>
```

(So e.g. `systemctl restart mcs-primproc` )

If you need to restart the whole installation use

```
systemctl restart mariadb-columnstore
```

## Interaction with MariaDB Server

MCS is one of the many [storage engines](https://mariadb.com/kb/en/choosing-the-right-storage-engine/) offered by MariaDB. A storage engine handles the SQL operations for a certain table type, e.g. Columnstore is designed for big data, uses a columnar storage system and can process petabytes of data. The default engine for MariaDB is InnoDB. You can see all currently available engines on your server by running the SQL statement: `SHOW ENGINES;` in your mariadb console. Columnstore needs to be explicitly installed, but if you’re reading this you probably built MariaDB and MCS from source for development purposes and should see it listed.

tbw 

## Troubleshooting

### Killing a process during Debugging

Especially during debugging you might end up killing a process, which leads to error messages like e.g.:

`ERROR 1815 (HY000): Internal error: MCS-2033: Error occurred when calling system catalog.` 

Which occurs when the `PrimProc` process is killed, but all other processes continue running and then cannot access the system catalog which is served by `PrimProc`.

You can verified that this happened by having a look at all running processes for mariadb/mysql via:

```bash
ps -axwffu | grep mysql
```

And restart any service via 

```bash
systemctl restart mcs-<process_name>
```