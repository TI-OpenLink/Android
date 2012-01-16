#!/usr/bin/env python

# repo local_manifest builder for wcs

# Creates a local_manifest.xml which points all available projects

import getopt, sys
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
    
    target_manifest = "local_manifest.xml"
    wlan_manifest = "wlan_android_local_manifest.xml"
    bt_manifest = "bt_android_local_manifest.xml"

    if len(args) > 0:
        target_manifest = str(args[0])
    if len(args) > 1:
        wlan_manifest = str(args[1])
    if len(args) > 2:
        bt_manifest = str(args[2])

    local_manifest = Element('manifest')
    new_tree = ElementTree(local_manifest)
    
    print "wlan local manifest file: " + str(wlan_manifest)
    tree_wlan = ElementTree()
    tree_wlan.parse(wlan_manifest)
    manifest_wlan = tree_wlan.getroot()
    
    print "bt local manifest file: " + str(bt_manifest)
    tree_bt = ElementTree()
    tree_bt.parse(bt_manifest)
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
    
    new_tree.write(target_manifest)
#    prettify(target_manifest)
    print "target local manifest file: " + str(target_manifest)


if __name__ == "__main__":
    main()

