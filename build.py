import argparse

import os
import sys

from generator import Generator

# Create the parser
my_parser = argparse.ArgumentParser(description='Generate script to Build Base')

# Add the arguments
my_parser.add_argument('PHP_Version',
                       metavar='version',
                       type=str,
                       help='The PHP Version')

my_parser.add_argument('--debug',
                       dest='Debug',
                       nargs="?",
                       const=True,
                       default=False,
                       help='Enable Debug Build (multiple layers)')

# Execute the parse_args() method
args = my_parser.parse_args()

gen = Generator(args.PHP_Version, args.Debug)
gen.build_base()
gen.build_cli()
gen.build_fpm()
gen.build_fpm_apache()
gen.build_fpm_nginx()
