#!/usr/bin/env python3
import sys
import os
import re
from jinja2 import Environment, FileSystemLoader
import json
from pprint import pprint
from optparse import OptionParser

PATH = os.path.dirname(os.path.abspath(__file__))

def getShellOptions():
  parser = OptionParser(usage="usage: %prog [options] SOURCE")
  return parser.parse_args()

def ensurelist(v):
  if v:
    return [ x for x in (v if isinstance(v, (list, tuple)) else [v]) ]
  else:
    return []

def main():
  (options,args) = getShellOptions()
  if not len(args) > 0:
    sys.exit("Please provide a source file")

  template_filename = args[0]

  if not os.path.isfile(template_filename):
    sys.exit("File %s does not exist." % (template_filename))

  jinja = Environment(loader=FileSystemLoader(os.path.dirname(os.path.abspath(template_filename))))
  jinja.filters['ensurelist'] = ensurelist

  template = jinja.get_template(os.path.basename(template_filename))

  context = { }

  for key in os.environ.keys():
    try:
      context[key] = json.loads( os.environ[key] )
    except Exception as err:
      context[key] = os.environ[key]

  print( template.render( context ) )

########################################

if __name__ == "__main__":
    main()
