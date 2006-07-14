#!/usr/bin/env python

from distutils.core import setup, Extension
import glob

setup(name='IcePy',
      version='ICEVERSION',
      description='Python Bindings for the ICE Middleware',
      author='Tiziano Mueller (only setup.py)',
      author_email='gentoo@dev-zero.ch',
      url='http://www.zeroc.com', 

      package_dir = {'': 'python'},
      packages=['.', 'Glacier2', 'IceBox', 'IceGrid', 'IcePatch2', 'IceStorm'],

      ext_modules      = [ Extension( 'IcePy',
				glob.glob('modules/IcePy/*.cpp'),
				include_dirs = [ 'modules/IcePy' ],
				library_dirs = [ '/usr/lib' ],
				libraries = [ 'Ice', 'IceUtil', 'Slice', ],
				extra_compile_args = ['-ftemplate-depth-128', '-D_REENTRANT'],
				) 
			],

     )
