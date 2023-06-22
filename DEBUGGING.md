## MCS Processes

MariaDB Columnstore runs as multiple processes which you can see for yourself with running `ps -axwffu | grep mysql` :

(? Why mysql)

```bash
ps -axwffu | grep mysql

root       |       \_ grep --color=auto mysql
mysql      /usr/bin/workernode DBRM_Worker1
mysql      /usr/bin/controllernode
mysql      /usr/bin/PrimProc
mysql      /usr/bin/WriteEngineServer
mysql      /usr/bin/DMLProc
mysql      /usr/bin/DDLProc
mysql      /usr/sbin/mariadbd

```

The different processes have the following tasks:

- **workernode**:
- **controllernode**:
- **PrimProc**:
- **WriteEngineServer**:
- **DMLProc**: Handle Data Manipulation Requests, e.g. inserting, updating or deleting data. (E.g. SQL Commands such as `INSERT`, `UPDATE`, or `DELETE`.)
- **DDLProc**: Handle Data Definition Requests, e.g. defining and managing the structure and schema of the database. (E.g. SQL Commands such as `CREATE`, `ALTER`, `DROP`.)
- **Mariadbd**:

## Debugging with Visual Studio Code

You can find debugging configurations for all relevant processes in `.vscode/launch.json` . To debug MCS processes we use the Attach debugging mode, where the VS Code’s debugger attaches to the already running process.

Therefore you need to have a running mariadb with MCS process to which you can attach to. 

E.g. you can start a mariadb console on your machine via typing `mariadb` in your terminal. You can then select a process to debug via the `Run and Debug` section of VS Code. Make sure to connect to the correct background process which services your opened MariaDB console. (In general it’s useful to have just one MariaDB process running.) 
You can now run a test query in your opened console and add breakpoints in your code to stop in parts of the code that interest you.

As MCS execution is distributed over multiple processes you have to identify the process that leverages the code you are interested in. Here are some pointers:

******************PrimProc:****************** 

- `dbcon/joblist`

******************Mariadbd:******************

- `dbcon/mysql`