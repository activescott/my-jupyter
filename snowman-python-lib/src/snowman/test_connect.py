import os
import unittest
from unittest.mock import patch
from pathlib import Path
from dotenv import load_dotenv
from .connect import connect, fetch


# TODO: see https://docs.python.org/3/library/unittest.html#module-unittest

THIS_DIR = os.path.dirname(__file__)
WORKSPACE_DIR = os.path.normpath(THIS_DIR + '../../../..')

class TestConnect(unittest.TestCase):
    '''
    Tests the snowman connect module
    '''
    @classmethod
    def setUpClass(cls):
        load_dotenv(dotenv_path=WORKSPACE_DIR + '/.env')

    def test_invalid_key_path(self):
        didExpectedExceptionOccur = False
        try:
            connect(private_key_path='/does-not-exist/foo.p8')
        except FileNotFoundError as ex:
            self.assertRegex(
                str(ex), 'No such file or directory: \'/does-not-exist/foo.p8\'')
            didExpectedExceptionOccur = True

        self.assertTrue(didExpectedExceptionOccur)

    def test_basic_connect(self):
        '''
        Basic test of connection - assumes key pair and environment variables are setup (could be conditionally skipped)
        '''
        #env = { '': '' }
        # with patch.object(os, 'environ', return_value=None) as mock_method:
        connect(
            private_key_path=WORKSPACE_DIR +
            '/snowflake-key-pair/rsa_key.p8')

    def test_basic_fetch(self):
        '''
        Basic test of query - assumes key pair and environment variables are setup (could be conditionally skipped)
        '''
        sql = 'SELECT CURRENT_TIMESTAMP;'
        cur = fetch(
            sql,
            private_key_path=WORKSPACE_DIR +
            '/snowflake-key-pair/rsa_key.p8')

        rows = cur.fetchmany(100)
        self.assertIsNotNone(rows)
        self.assertEqual(1, len(rows))
        row = rows[0]
        self.assertEqual(1, len(row))
        print(row)

    def tets_reads_args(self):
        '''should read values from the environment'''
        self.skipTest('todo')

    def tets_reads_environment(self):
        '''should read values from the environment'''
        self.skipTest('todo')

    def tets_fails_if_empty_environment_and_args(self):
        '''should fail when value isn't in environment'''
        self.skipTest('todo')


if __name__ == '__main__':
    unittest.main()
