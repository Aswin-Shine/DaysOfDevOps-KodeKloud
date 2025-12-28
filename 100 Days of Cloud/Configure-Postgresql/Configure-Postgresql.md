The Nautilus application development team has shared that they are planning to deploy one newly developed application on Nautilus infra in Stratos DC.

The application uses PostgreSQL database, so as a pre-requisite we need to set up PostgreSQL database server as per requirements shared below:

PostgreSQL database server is already installed on the Nautilus database server.  
a. Create a database user kodekloud_rin and set its password to ksH85UJjhb.
b. Create a database kodekloud_db5 and grant full permissions to user kodekloud_rin on this database.

Note: Please do not try to restart PostgreSQL server service.

Solution:

```
ssh peter@stdb01
psql -U postgres
CREATE USER kodekloud_rin WITH PASSWORD 'ksH85UJjhb';
CREATE DATABASE kodekloud_db5;
GRANT ALL PRIVILEGES ON DATABASE "kodekloud_db5 to kodekloud_rin;
\l
\du
```
