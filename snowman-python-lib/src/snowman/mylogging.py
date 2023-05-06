import logging
from os.path import basename


def getCallerModule():
    """
    Returns the name of the module that the caller of the caller of this function is from.
    """
    callerModule = '<unknown>'
    try:
        from inspect import stack
        frames = stack()
        callerModule = basename(frames[2][1])
        if callerModule[-3:] == '.py':
            callerModule = callerModule[:-3]
    except BaseException:  # pylint: disable=bare-except
        pass
    return callerModule


def log(*args):
    callerModule = getCallerModule()
    l = logging.getLogger(callerModule)
    l.info(u' '.join(map(lambda a: str(a), args))
           )  # pylint: disable=unnecessary-lambda


def info(*args):
    callerModule = getCallerModule()
    l = logging.getLogger(callerModule)
    l.info(u' '.join(map(lambda a: str(a), args))
           )  # pylint: disable=unnecessary-lambda


def debug(*args):
    callerModule = getCallerModule()
    l = logging.getLogger(callerModule)
    l.debug(u' '.join(map(lambda a: str(a), args))
            )  # pylint: disable=unnecessary-lambda
