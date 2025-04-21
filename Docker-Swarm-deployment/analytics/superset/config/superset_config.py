# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# This file is included in the final Docker image and SHOULD be overridden when
# deploying the image to prod. Settings configured here are intended for use in local
# development environments. Also note that superset_config_docker.py is imported
# as a final step as a means to override "defaults" configured here
#
import logging

# ? Formatted logging for Loki
# from logging.handlers import RotatingFileHandler

import os

from celery.schedules import crontab
from flask_caching.backends.filesystemcache import FileSystemCache
from flask import Flask, session, g, request, current_app, jsonify
from flask.sessions import SecureCookieSessionInterface
import requests

# from console_log import ConsoleLog

# def FLASK_APP_MUTATOR(app):
#     app.wsgi_app = ConsoleLog(app.wsgi_app, app.logger)


# ? Keycloak Imports 
from keycloak_security_manager import OIDCSecurityManager
from flask_appbuilder.security.manager import AUTH_OID, AUTH_REMOTE_USER, AUTH_DB, AUTH_LDAP, AUTH_OAUTH
import os

# ? Importing Prometheus Client
# from prometheus_client import make_wsgi_app
# from werkzeug.middleware.dispatcher import DispatcherMiddleware


# from setup import BASE_DIR
# from superset.config import BASE_DIR

logger = logging.getLogger()

# ? Keycloak Config
curr = os.path.abspath(os.getcwd())

AUTH_TYPE = AUTH_OID
SECRET_KEY = os.getenv('SECRET_KEY')
OIDC_CLIENT_SECRETS = curr + os.getenv('OIDC_CLIENT_SECRETS')
OIDC_ID_TOKEN_COOKIE_SECURE = False
OIDC_OPENID_REALM: os.getenv('OIDC_OPENID_REALM')
OIDC_INTROSPECTION_AUTH_METHOD: os.getenv('OIDC_INTROSPECTION_AUTH_METHOD')
CUSTOM_SECURITY_MANAGER = OIDCSecurityManager
# Will allow user self registration, allowing to create Flask users from Authorized User
AUTH_USER_REGISTRATION = True

# The default user self registration role
AUTH_USER_REGISTRATION_ROLE = 'Public'

def make_session_permanent():
    '''
    Enable maxAge for the cookie 'session'
    '''
    session.permanent = True

# TODO: Setup Prometheus metrics 


# # ? Enable Prometheus metrics endpoint
# def prometheus_metrics(app):
#     logger.info('[This is a prometheus metric log]')
#     # This will expose Prometheus metrics on the /metrics endpoint
#     app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
#         '/metrics': make_wsgi_app()
#     })
#     return app


def middleware_function():
    logger.info('[This is a middleware function]')
    if g.user is not None and g.user.is_authenticated:
        logger.info(g.user) 

        # # TODO: Fetch access token
        # cookie_value = request.cookies.get('session')
        # session_serializer = SecureCookieSessionInterface() \
        #                 .get_signing_serializer(current_app)
        # decoded_session = session_serializer.loads(cookie_value)
        # session_token = decoded_session['oidc_auth_token']['access_token']
        # try:
        #     token_url = 'https://cos.iudx.org.in/auth/v1/token'

        #     headers = {
        #         'authorization': f'Bearer {session_token}'
        #     }

        #     data = {
        #         'itemId': 'rs.cos.iudx.org.in',
        #         'itemType': 'resource_server',
        #         'role': 'consumer'
        #     }

        #     response = requests.post(token_url, headers=headers, json=data)

        #     if response.status_code == 200:
        #         logger.info(f"[Token from IUDX]: {response.json()['results']['accessToken']}")
        #     else:
        #         logger.info('Error fetching token')

        # except Exception as e:
        #     print(f"Error fetching data: {e}")
        
        path = request.path
        if '/api/v1/chart' in path:
            logger.info('[This is a chart endpoint]')
            chart_id = path.split('/')[-1]
            logger.info(f"Chart ID: {chart_id}")
        
        if '/api/v1/dashboard' in path:
            logger.info('[This is a dashboard endpoint]')
            dashboard_id = path.split('/')[-1]
            logger.info(f"Dashboard ID: {dashboard_id}")


    else:
        logger.error('User not logged in')

    # if g.user is not None and g.user.is_authenticated:
    #     username = g.user.username
    #     email = g.user.email
    #     roles = [role.name for role in g.user.roles]

    #     # Example: Print user details (for debugging)
    #     print(f"User: {username}, Email: {email}, Roles: {roles}")

    #     # You can now use these details for any purpose, like logging, custom rules, etc.
    # else:
    #     print("No authenticated user found")

# Set up max age of session to 24 hours
# PERMANENT_SESSION_LIFETIME = timedelta(hours=24)
def FLASK_APP_MUTATOR(app: Flask) -> None:
    app.before_request_funcs.setdefault(None, []).append(middleware_function)
    # app.before_request_funcs.setdefault(None, []).extend([middleware_function, prometheus_metrics])



# ? Enable Structured logging for Loki for easier log parsing
# LOGGING = {`
#     'version': 1,
#     'disable_existing_loggers': False,
#     'handlers': {
#         'file': {
#             'level': 'DEBUG',
#             'class': 'logging.handlers.RotatingFileHandler',
#             'filename': '/var/log/superset/superset.log',
#             'maxBytes': 1024000,  # 1MB log size
#             'backupCount': 3,
#         },
#     },
#     'loggers': {
#         'superset': {
#             'level': 'DEBUG',
#             'handlers': ['file'],
#         },
#     },
# }`

TALISMAN_ENABLED = True
TALISMAN_CONFIG = {
    "content_security_policy": {
        "base-uri": ["'self'"],
        "default-src": ["'self'"],
        "img-src": [
            "'self'",
            "blob:",
            "data:",
            "https://apachesuperset.gateway.scarf.sh",
            "https://static.scarf.sh/",
            "https://avatars.slack-edge.com",
        ],
        "worker-src": ["'self'", "blob:"],
        "connect-src": [
            "'self'",
            "https://api.mapbox.com",
            "https://events.mapbox.com",
        ],
        "object-src": "'none'",
        "style-src": [
            "'self'",
            "'unsafe-inline'",
        ],
        "frame-ancestors": ["*"],
        "script-src": ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
    },
    "content_security_policy_nonce_in": ["script-src"],
    "force_https": False,
    "session_cookie_secure": False,
}

GUEST_ROLE_NAME= 'embed_dashboard'
GUEST_TOKEN_JWT_SECRET = "test-guest-secret-change-me"
GUEST_TOKEN_JWT_EXP_SECONDS = 3600
CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["*"],
    # TODO: Add allowed domains
    "origins": ["*"]
}



DATABASE_DIALECT = os.getenv("DATABASE_DIALECT")
DATABASE_USER = os.getenv("DATABASE_USER")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
DATABASE_HOST = os.getenv("DATABASE_HOST")
DATABASE_PORT = os.getenv("DATABASE_PORT")
DATABASE_DB = os.getenv("DATABASE_DB")

EXAMPLES_USER = os.getenv("EXAMPLES_USER")
EXAMPLES_PASSWORD = os.getenv("EXAMPLES_PASSWORD")
EXAMPLES_HOST = os.getenv("EXAMPLES_HOST")
EXAMPLES_PORT = os.getenv("EXAMPLES_PORT")
EXAMPLES_DB = os.getenv("EXAMPLES_DB")

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = (
    f"{DATABASE_DIALECT}://"
    f"{DATABASE_USER}:{DATABASE_PASSWORD}@"
    f"{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE_DB}"
)

SQLALCHEMY_EXAMPLES_URI = (
    f"{DATABASE_DIALECT}://"
    f"{EXAMPLES_USER}:{EXAMPLES_PASSWORD}@"
    f"{EXAMPLES_HOST}:{EXAMPLES_PORT}/{EXAMPLES_DB}"
)

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")
REDIS_CELERY_DB = os.getenv("REDIS_CELERY_DB", "0")
REDIS_RESULTS_DB = os.getenv("REDIS_RESULTS_DB", "1")

RESULTS_BACKEND = FileSystemCache("/app/superset_home/sqllab")

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": REDIS_RESULTS_DB,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

AUTH_ROLES_MAPPING = { 
  'SUPERSET_USERS': ['Admin'], 
  'SUPSERSET_ADMIN': ['Admin'],
  'SUPSERSET_ALPHA': ["Admin"],
  'SUPSERSET_GAMMA': ["Admin"],
}

AUTH_ROLES_SYNC_AT_LOGIN = False


class CeleryConfig:
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CELERY_DB}"
    imports = (
        "superset.sql_lab",
        "superset.tasks.scheduler",
        "superset.tasks.thumbnails",
        "superset.tasks.cache",
    )
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_RESULTS_DB}"
    worker_prefetch_multiplier = 1
    task_acks_late = False
    beat_schedule = {
        "reports.scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=10, hour=0),
        },
    }


CELERY_CONFIG = CeleryConfig

FEATURE_FLAGS = {
    "ALERT_REPORTS": True, 
    # ? Enable Dashboard RBAC in UI
    "DASHBOARD_RBAC": True
}
ALERT_REPORTS_NOTIFICATION_DRY_RUN = True
WEBDRIVER_BASEURL = "http://superset:8088/"  # When using docker compose baseurl should be http://superset_app:8088/
# The base URL for the email report hyperlinks.
WEBDRIVER_BASEURL_USER_FRIENDLY = WEBDRIVER_BASEURL
SQLLAB_CTAS_NO_LIMIT = True

#
# Optionally import superset_config_docker.py (which will have been included on
# the PYTHONPATH) in order to allow for local settings to be overridden
#
try:
    import superset_config_docker
    from superset_config_docker import *  # noqa

    logger.info(
        f"Loaded your Docker configuration at " f"[{superset_config_docker.__file__}]"
    )
except ImportError:
    logger.info("Using default Docker config...")