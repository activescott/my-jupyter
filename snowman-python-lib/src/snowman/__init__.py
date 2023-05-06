from .mylogging import debug
import logging
from .constants import PKG_NAME, PKG_VERSION
logging.basicConfig(
    format='%(asctime)s %(levelname)s %(name)s %(message)s',
    level=logging.INFO)

# because
# http://stackoverflow.com/questions/37252527/how-to-hide-py4j-java-gatewayreceived-command-c-on-object-id-p0#37252533
logger = logging.getLogger('py4j')
if logger.name[:4] == 'py4j':
    logger.setLevel(logging.ERROR)

# now that logging is initiatlized can load sslogging

debug('{} version {} loaded.'.format(PKG_NAME, PKG_VERSION))
