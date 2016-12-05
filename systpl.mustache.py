#!/usr/bin/env python
import sys 
import os
import re
import pystache
import json
from pprint import pprint
from optparse import OptionParser
 
PATH = os.path.dirname(os.path.abspath(__file__))

def getShellOptions():
  parser = OptionParser(usage="usage: %prog [options] SOURCE")
  return parser.parse_args()
 
def main():
  (options,args) = getShellOptions()
  if not len(args) > 0:
    sys.exit("Please provide a source file")

  template_filename = args[0]

  if not os.path.isfile(template_filename):
    sys.exit("File %s does not exist." % (template_filename))

  with open(template_filename) as f:
    data = f.read()

  context = { }

  for key in os.environ.keys():
    is_list = re.search( r'\|', os.environ[key])
    if is_list:
      context[key] = os.environ[key].split('|')
    else:
      context[key] = os.environ[key]

  print( pystache.render( data, context) )
  
 
########################################
 
if __name__ == "__main__":
    main()
