#!/bin/sh -e

# on sauvegarde l'emplacement actuel
CURRENT_PWD=`pwd -P`

echo CURRENT_PWD ${CURRENT_PWD}
echo dirname "$(dirname "$(readlink -f "$0")")"


# Définition des variables pour download et install Oracle XE
export ORACLE_FILE="oracle-xe-11.2.0-1.0.x86_64.rpm.zip"
export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"
export ORACLE_SID="XE"

.travis/oracle/download.sh

.travis/oracle/install.sh

# Integrate Oracle Libraries (use by oracledb at build)
export OCI_LIB_DIR="/u01/app/oracle/product/11.2.0/xe/lib"
export OCI_INC_DIR="/u01/app/oracle/product/11.2.0/xe/rdbms/public"


#    - OCI_LIB_DIR=/u01/app/oracle/product/11.2.0/xe/lib
#    - OCI_INC_DIR=/u01/app/oracle/product/11.2.0/xe/rdbms/public
#    - LD_LIBRARY_PATH=/u01/app/oracle/product/11.2.0/xe/lib

# Integrate Oracle Libraries (use by oracledb at execution)
export LD_LIBRARY_PATH="/u01/app/oracle/product/11.2.0/xe/lib/"
sudo ldconfig


# Create User for integrations tests
"$ORACLE_HOME/bin/sqlplus" -L -S / AS SYSDBA <<SQL
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY welcome;
SQL

# Create User for integrations tests
"$ORACLE_HOME/bin/sqlplus" -L -S / AS SYSDBA <<SQL
CREATE USER SEQUELIZE
  IDENTIFIED BY test
  DEFAULT TABLESPACE SYSAUX
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 2 Roles for SEQUELIZE 
  GRANT CONNECT TO SEQUELIZE;
  GRANT AUTHENTICATEDUSER TO SEQUELIZE;
  ALTER USER SEQUELIZE DEFAULT ROLE NONE;
  -- 18 System Privileges for SEQUELIZE 
  GRANT CREATE ANY TYPE TO SEQUELIZE;
  GRANT CREATE ANY TRIGGER TO SEQUELIZE;
  GRANT CREATE VIEW TO SEQUELIZE;
  GRANT CREATE SYNONYM TO SEQUELIZE;
  GRANT CREATE TABLESPACE TO SEQUELIZE;
  GRANT CREATE ANY INDEXTYPE TO SEQUELIZE;
  GRANT CREATE ANY SEQUENCE TO SEQUELIZE;
  GRANT CREATE ANY MATERIALIZED VIEW TO SEQUELIZE;
  GRANT CREATE TYPE TO SEQUELIZE;
  GRANT CREATE SEQUENCE TO SEQUELIZE;
  GRANT CREATE ANY INDEX TO SEQUELIZE;
  GRANT CREATE ANY TABLE TO SEQUELIZE;
  GRANT CREATE TABLE TO SEQUELIZE;
  GRANT CREATE SESSION TO SEQUELIZE;
  GRANT CREATE TRIGGER TO SEQUELIZE;
  GRANT CREATE ANY PROCEDURE TO SEQUELIZE;
  GRANT CREATE ANY VIEW TO SEQUELIZE;
  GRANT CREATE ANY SYNONYM TO SEQUELIZE;
  -- 1 Tablespace Quota for SEQUELIZE 
  ALTER USER SEQUELIZE QUOTA UNLIMITED ON SYSAUX;
SQL
