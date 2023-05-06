This folder is to hold your generated key pair. Use the steps to generate both `rsa_key.p8` and `rsa_key.pub` and then put them in the `snowflake-key-pair/` folder in this repository (but **do not** commit them).

This readme should give you the step-by-step you need, but the relevant official docs on this from snowflake are the following:

- [Overview of key pair authentication and generating keys](https://docs.snowflake.com/en/user-guide/key-pair-auth.html)
- [Using Key Pair Authentication w/ the python connector](https://docs.snowflake.com/en/user-guide/python-connector-example.html#using-key-pair-authentication-key-pair-rotation)

## Generating & Using Key Pair

Using Key Pair authentication involves the following high level steps:

1. Generate key
2. Register key in snowflake (via BI team)
3. Using key in Python Notebooks

Each of these steps is covered in more detail below.

## Prerequisites

- You already have a snowflake account (e.g you can login via the snowflake web app)
- You are on macOS (this probably works on Linux, doubtful on windows)

## (One-Time) Step 1: Generate Key

Follow steps at https://docs.snowflake.com/en/user-guide/python-connector-example.html#using-key-pair-authentication to generate the key (use encrypted version). Essentially in your terminal go to the `./snowflake-key-pair` directory in this repo and run the following:

```
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8
```

You will be prompted for a password (more on that below).

Now generate the _public_ key from the private key you generated:

```
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub
```

Now if you look in the `./snowflake-key-pair` directory you should see a `rsa_key.p8` file (your private key) and `rsa_key.pub` files. DO NOT COMMIT THEM. Keep your private key private.

## (One-Time) Step 2. Register key in snowflake

_NOTE: You'll probably need a snowflake admin to do this._

1. Provide your **public** key (**not** your *private* key) to the snowflake admin.
2. Snowflake admin runs the following SQL (were `jsmith` is your snowflake username and `decafbad...` is your public key - REMOVE NEWLINES): `alter user jsmith set rsa_public_key='decafbad...';`

Once they get back to you and confirm that your key is registered follow on to the step below and you should be up and running.

## 3. Using key in Python Notebooks

In the `.env` file in the root of the repo, set the `SNOWFLAKE_PRIVATE_KEY_PASSPHRASE` variable to the password you created when generating your private key. This is used in the python scripts to load your private key.

