import os
import pandas as pd
import snowflake.connector
from .env import env_or_fail, env_or_default
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization
from .constants import DEFAULT_PRIVATE_KEY_PATH, DEFAULT_KEY_PASSPHRASE_VAR

def private_key_bytes(
        key_path=DEFAULT_PRIVATE_KEY_PATH,
        key_passphrase_var=DEFAULT_KEY_PASSPHRASE_VAR):
    '''
    Loads the private key for snowflake key-pair authentication as explained at https://docs.snowflake.com/en/user-guide/python-connector-example.html#using-key-pair-authentication
    '''
    with open(key_path, "rb") as key:
        p_key = serialization.load_pem_private_key(
            key.read(),
            password=os.environ[key_passphrase_var].encode(),
            backend=default_backend()
        )

    pkb = p_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption())

    return pkb


def connect(
        account=None,
        warehouse=None,
        database=None,
        schema=None,
        log_level="WARN",
        private_key_path=DEFAULT_PRIVATE_KEY_PATH,
        private_key_passphrase_var=DEFAULT_KEY_PASSPHRASE_VAR):
    '''
    Creates and returns a connection from the snowflake python connector.
    '''
    snow_log_level(log_level)

    ctx = snowflake.connector.connect(
        user=env_or_fail('SNOWFLAKE_USER'),
        private_key=private_key_bytes(
            private_key_path,
            private_key_passphrase_var),
        account=account or env_or_fail('SNOWFLAKE_ACCOUNT'),
        warehouse=warehouse or env_or_default('SNOWFLAKE_WAREHOUSE'),
        database=database or env_or_default('SNOWFLAKE_DATABASE'),
        schema=schema or env_or_default('SNOWFLAKE_SCHEMA'))

    return ctx


def fetch(
        sql,
        account=None,
        warehouse=None,
        database=None,
        schema=None,
        parameters=None,
        existing_connection=None,
        log_level="WARN",
        private_key_path=DEFAULT_PRIVATE_KEY_PATH,
        private_key_passphrase_var=DEFAULT_KEY_PASSPHRASE_VAR):
    '''
    Given a SQL string and optional connection information, executes and returns a cursor ready to be read from.
    '''
    snow_log_level(log_level)

    ctx = connect(
        account,
        warehouse,
        database,
        schema,
        log_level,
        private_key_path=private_key_path,
        private_key_passphrase_var=private_key_passphrase_var
    ) if existing_connection is None else existing_connection

    # Create a cursor object.
    cur = ctx.cursor()

    # Execute a statement that will generate a result set.
    cur.execute(sql, parameters)
    return cur


def snow_log_level(level):
    '''
    Sets the logging level on the snowflake connector for python to the specified level.
    level must be WARN, INFO, ERROR, etc.
    NOTE: because snowflake :( https://github.com/snowflakedb/snowflake-connector-python/issues/145
    '''
    import logging
    for lname in [
        "snowflake.connector.connection",
            "snowflake.connector.json_result"]:
        logging.getLogger(lname).setLevel(level)
    for lname in ["snowflake.connector.cursor"]:
        # NOTE: sometimes it is helpful to force the cursor to INFO because for
        # progress output
        logging.getLogger(lname).setLevel(level)
