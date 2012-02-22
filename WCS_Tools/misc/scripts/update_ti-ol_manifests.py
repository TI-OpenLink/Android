#!/usr/bin/env python

# Geenrate the ti-ol android manifest from a complete android manifest

import getopt, sys
import string;
from xml.etree.ElementTree import ElementTree, Element
import httplib
import xml.dom.minidom
from xml.dom import minidom

def prettify(name):
    dom = minidom.parse(name)
    f = open(name, "w")
    f.write(dom.toprettyxml(indent="	", newl="\n", encoding='UTF-8'))
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

    source_manifest = "manifest.xml"
    target_manifest_name = "ti-ol-android-manifest.R5.yy.xml"

    if len(args) > 0:
        source_manifest = str(args[0])
    if len(args) > 1:
        target_manifest_name = str(args[1])

    target_manifest = Element('manifest')
    new_tree = ElementTree(target_manifest)

    tree_android = ElementTree()
    tree_android.parse(source_manifest)
    manifest_android = tree_android.getroot()
    
    print "Generating ti-ol manifest.xml"
    
    for remote in tree_android.getroot().findall("remote"):
        if remote.get("name").find("TI-OpenLink") != -1:
            target_manifest.append(remote)
            print "added remote: " + remote.get("name")
    
    for project in tree_android.getroot().findall("project"):
        project_remote = project.get("remote")
        if project_remote == None:
            continue
        if project_remote.find("TI-OpenLink") != -1:
            target_manifest.append(project)
            print "added project: " + project.get("name")
    
    new_tree.write(target_manifest_name)
    prettify(target_manifest_name)
    print "target manifest file: " + str(target_manifest_name)


if __name__ == "__main__":
    main()

