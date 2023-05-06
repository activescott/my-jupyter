import os
import pandas as pd
from .connect import connect, snow_log_level
from .constants import DEFAULT_PRIVATE_KEY_PATH, DEFAULT_KEY_PASSPHRASE_VAR

# TODO: see https://docs.snowflake.com/en/user-guide/python-connector-pandas.html#reading-data-from-a-snowflake-database-to-a-pandas-dataframe
def to_pandas(cur):
    '''
    Given a cursor that has had `cursor.execute` called on it to fetch its data, will return the data as a pandas DataFrame.
    '''
    dfAll = df = pd.DataFrame(
        data=None, columns=[
            c[0] for c in cur.description])
    while True:
        dat = cur.fetchmany(10000)
        if not dat:
            break
        df = pd.DataFrame(dat, columns=[c[0] for c in cur.description])
        dfAll = pd.concat([dfAll, df])
    return dfAll


def fetch_pandas(
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
    Given a SQL string and optional connection information, returns a pandas DataFrame with the data.
    '''
    snow_log_level(log_level)

    ctx = connect(
        account,
        warehouse,
        database,
        schema,
        log_level,
        private_key_path,
        private_key_passphrase_var) if existing_connection is None else existing_connection

    # Create a cursor object.
    cur = ctx.cursor()

    # Execute a statement that will generate a result set.
    cur.execute(sql, parameters)
    return to_pandas(cur)
