#!/usr/bin/env python

def removeLine(path):
	lines = file("manifest.xml","rb").readlines()
	for line in lines:
		if line.find(path) != -1:
			print "removing line: "+path
			lines.remove(line)
	xml2 = file("manifest.xml","wb")
	for line in lines:
        	xml2.write(line)

for line in file("local_manifest.xml","rb").readlines():
	startPos = line.find("path=")
	if startPos != -1:
		startPos=startPos+5
		path = line[startPos:line.find(" ",startPos)].strip()
		removeLine(path)

