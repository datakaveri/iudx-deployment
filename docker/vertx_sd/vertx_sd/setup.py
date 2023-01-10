from setuptools import setup

setup(name='vertx_sd',
      version='0.1',
      description='Prometheus Service Discovery for Vert.x Cluster',
      author='srinskit',
      packages=['vertx_sd'],
      install_requires=['kazoo', ],
      entry_points={
          'console_scripts': ['vertx_sd=vertx_sd.main:cmd'],
      },
      zip_safe=False)
