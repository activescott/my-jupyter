import os


def env_or_default(env_name, default_value=None):
    if env_name in os.environ is not None:
        return os.environ[env_name]
    return default_value


def env_or_fail(env_name):
    if env_name in os.environ is not None:
        return os.environ[env_name]
    else:
        raise ValueError(
            f'Setting `{env_name}` must be provided as an OS environment variable.')
