import os
import unittest
from unittest.mock import patch
from pathlib import Path
from dotenv import load_dotenv
from .connect import connect, fetch
from .pandas import fetch_pandas

# TODO: Baseclass for tests that includes setup .env and directories
THIS_DIR = os.path.dirname(__file__)
WORKSPACE_DIR = os.path.normpath(THIS_DIR + '../../../..')


class TestPandas(unittest.TestCase):
    '''
    Tests the snowman connect module
    '''
    @classmethod
    def setUpClass(cls):
        load_dotenv(dotenv_path=WORKSPACE_DIR + '/.env')

    def test_basic_fetch(self):
        '''
        Basic test of query in pandas + snowflake
        '''
        sql = 'SELECT CURRENT_TIMESTAMP;'
        df = fetch_pandas(
            sql,
            private_key_path=WORKSPACE_DIR +
            '/snowflake-key-pair/rsa_key.p8')
        self.assertEqual(1, df.shape[0])
        print(df)
