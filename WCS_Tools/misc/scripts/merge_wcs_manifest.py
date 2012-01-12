#!/usr/bin/env python

# repo local_manifest builder for wcs

# Creates a local_manifest.xml which points all available projects

import string;
from xml.etree.ElementTree import ElementTree, Element
import httplib
from xml.dom import minidom

def to_github_name(s):
  s = s.lower()
  s = string.replace(s, '/', '_')
  return s

def verify_github_project(name):
  github = httplib.HTTPSConnection("github.com", timeout=5)
  github.request("HEAD", "/android/%s" % name, None, {'Connection': 'close'})
  res = github.getresponse()
  return res.status != httplib.NOT_FOUND

def prettify(name):
    dom = minidom.parse(name)
    f = open(name, "w")
    f.write(dom.toprettyxml(indent="  "))
    f.close()

local_manifest = Element('manifest')
new_tree = ElementTree(local_manifest)

tree_wlan = ElementTree()
tree_wlan.parse("wlan_android_manifest.xml")
manifest_wlan = tree_wlan.getroot()

tree_bt = ElementTree()
tree_bt.parse("blueti_android_manifest.xml")
manifest_bt = tree_bt.getroot()

print "Generating combined local_manifest.xml"

for remote in tree_wlan.getroot().findall("remote"):
	local_manifest.append(remote)

for remote in tree_bt.getroot().findall("remote"):
	local_manifest.append(remote)

for project in tree_wlan.getroot().findall("project"):
	local_manifest.append(project)

for project in tree_bt.getroot().findall("project"):
	local_manifest.append(project)

new_tree.write("local_manifest.xml")
prettify("local_manifest.xml")

