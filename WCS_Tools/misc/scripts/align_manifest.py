#!/usr/bin/env python

import getopt, sys

def usage():
	print "this script removes the local_manifest.xml projects from the manifest.xml"
	print "arguments (optional):"
	print "1. local_manifest file name (default: local_manifest.xml)"
	print "2. manifest file name (default: manifest.xml)"

def removeLine(manifest, path):
	lines = file(str(manifest),"rb").readlines()
	for line in lines:
		if line.find(path) != -1:
			print "removing line: "+path
			lines.remove(line)
	xml2 = file(str(manifest),"wb")
	for line in lines:
        	xml2.write(line)

def scanManifest(local_manifest, manifest):
	for line in file(local_manifest,"rb").readlines():
		startPos = line.find("path=")
		if startPos != -1:
			startPos=startPos+5
			path = line[startPos:line.find(" ",startPos)].strip()
			removeLine(manifest, path)

def main():
	try:
		opts, args = getopt.getopt(sys.argv[1:], "ho:v", ["help", "output="])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)
	output = None
	verbose = False
	for o, a in opts:
		if o == "-v":
			verbose = True
		elif o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-o", "--output"):
			output = a
		else:
			assert False, "unhandled option"
	
	local_manifest="local_manifest.xml"
	manifest="manifest.xml"
	if len(args) >= 1:
		local_manifest = str(args[0])
	if len(args) >= 2:
		manifest = str(args[1])
	print "local_manifest.xml: " + str(local_manifest)
	print "manifest.xml: " + str(manifest)
	scanManifest(local_manifest, manifest)

if __name__ == "__main__":
    main()