#!/usr/bin/python
from optparse import OptionParser
import os
import sys

parser = OptionParser()
parser.add_option('-i', '--input', dest="input", help='Input file.')
parser.add_option('-o', '--outpit', dest="output", help='Output file.')

(options, args) = parser.parse_args()
input = open(options.input, 'r')

start = 'METABANK'
end = '1VISA CONFIDENTIAL: CLIENT USE ONLY                '

for line in input:
	if start in line:
		datablock = True;
	if end in line:
		if start in line:
			datablock = True;
		else:
			datablock = False
	if datablock == True:
		sys.stdout.write (line)
