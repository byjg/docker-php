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

my_parser.add_argument('--build-base',
                       dest='buildBase',
                       nargs="?",
                       const="base",
                       default="",
                       help='Build Base')

my_parser.add_argument('--build-cli',
                       dest='buildCli',
                       nargs="?",
                       const="cli",
                       default="",
                       help='Build Cli')

my_parser.add_argument('--build-fpm',
                       dest='buildFpm',
                       nargs="?",
                       const="fpm",
                       default="",
                       help='Build Fpm')

my_parser.add_argument('--build-fpm-apache',
                       dest='buildFpmApache',
                       nargs="?",
                       const="fpm_apache",
                       default="",
                       help='Build fpm-apache')

my_parser.add_argument('--build-fpm-nginx',
                       dest='buildFpmNginx',
                       nargs="?",
                       const="fpm_nginx",
                       default="",
                       help='Build Fpm-nginx')

# Execute the parse_args() method
args = my_parser.parse_args()

gen = Generator(args.PHP_Version, args.Debug)

cmd_list = []
cmd_list.append(args.buildBase) if args.buildBase != "" else None
cmd_list.append(args.buildCli) if args.buildCli != "" else None
cmd_list.append(args.buildFpm) if args.buildFpm != "" else None
cmd_list.append(args.buildFpmApache) if args.buildFpmApache != "" else None
cmd_list.append(args.buildFpmNginx) if args.buildFpmNginx != "" else None

[getattr(gen, "build_" + cmd)() for cmd in cmd_list]
