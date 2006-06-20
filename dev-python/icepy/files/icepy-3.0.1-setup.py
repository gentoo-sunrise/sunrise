#!/usr/bin/env python

from distutils.core import setup, Extension

setup(name='IcePy',
      version='3.0.1',
      description='Python Bindings for the ICE Middleware',
      author='Tiziano Mueller (only setup.py)',
      author_email='gentoo@dev-zero.ch',
      url='http://www.zeroc.com', 

      package_dir = {'': 'python'},
      packages=['.', 'Glacier2', 'IceBox', 'IceGrid', 'IcePatch2', 'IceStorm'],

      ext_modules      = [ Extension( 'IcePy', 
				[ 
				'modules/IcePy/Communicator.cpp',
				'modules/IcePy/Connection.cpp',
				'modules/IcePy/Current.cpp',
				'modules/IcePy/Init.cpp',
				'modules/IcePy/Logger.cpp',
				'modules/IcePy/ObjectAdapter.cpp',
				'modules/IcePy/ObjectFactory.cpp',
				'modules/IcePy/Operation.cpp',
				'modules/IcePy/Properties.cpp',
				'modules/IcePy/Proxy.cpp',
				'modules/IcePy/Slice.cpp',
				'modules/IcePy/Types.cpp',
				'modules/IcePy/Util.cpp'
				],
				include_dirs = [ 'modules/IcePy' ],
				library_dirs = [ '/usr/lib' ],
				libraries = [ 'Ice', 'IceUtil', 'Slice', ],
				extra_compile_args = ['-ftemplate-depth-128', '-D_REENTRANT', '-O3'],
				) 
			],

     )
