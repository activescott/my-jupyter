"""A setuptools based setup module.

See:
https://packaging.python.org/tutorials/packaging-projects/
https://packaging.python.org/en/latest/distributing.html
https://github.com/pypa/sampleproject
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages, find_namespace_packages
# To use a consistent encoding
from codecs import open
from os import path
from snowman.constants import PKG_VERSION, PKG_NAME

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name=PKG_NAME,
    version=PKG_VERSION,
    description='A python package that makes it easier to work with Snowflake data in python.',
    long_description=long_description,
    author='Scott Willeke',
    author_email='scott@willeke.com',
    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    # See https://packaging.python.org/guides/packaging-namespace-packages/#native-namespace-packages
    packages=find_namespace_packages(exclude=['contrib', 'docs', 'tests']),
    python_requires='>=3.10',
    
    # List run-time dependencies here.  These will be installed by pip when
    # your project is installed. For an analysis of "install_requires" vs pip's
    # requirements files see:
    # https://packaging.python.org/en/latest/requirements.html
    install_requires=[
        'snowflake-connector-python==2.8.3',
        'cryptography>=38.0.4'
    ],

    # List additional groups of dependencies here (e.g. development
    # dependencies). You can install these using the following syntax,
    # for example:
    # $ pip install -e .[dev,test]
    extras_require={
        'dev': [],
        'test': [],
    },
)
