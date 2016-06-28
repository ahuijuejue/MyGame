#!/usr/bin/env python

import hashlib
import sys 
import os

def hexstr(s):
    hs = ""
    for i in range(len(s)):
        hs += '%02X' % ord(s[i])
    return hs

def convert_path(path):
    while path[-1] == " ":
        path = path[0 : -1]
    if path[-1] != "/":
        path = path + "/"
    return path

def main():
    if len(sys.argv) != 3:
        sys.exit('Usage: %s file version' % sys.argv[0])

    filename = sys.argv[1]
    version = sys.argv[2]
    filepath = os.path.dirname(filename)
    filepath = convert_path(filepath)
    filesize = os.path.getsize(filename)
    print "file name:", filename
    print "version:", version
    m = hashlib.md5()
    fp = file(filename,'rb')
    while True:
        blk = fp.read(4096) # 4KB per block
        if not blk: break
        hs = hexstr(blk)
        m.update(hs)
    fp.close()

    absfile = filename
    idx = absfile.rfind("/")
    if idx >=0:
        absfile = absfile[idx+1:]

    ms = m.hexdigest()
    buf = "local list = {\n\tver = \""+version+"\",\n\tstage = {\n"
    buf += "\t\t{name=\"" + absfile + "\", code=\""
    buf += ms + "\", act=\"load\", size="
    buf += str(filesize) + "},\n"
    buf += "\t},\n\tremove={\n\t},\n}\nreturn list"

    flist = open(filepath + 'flist', 'w+') 
    flist.write(buf)
    flist.close()

if __name__ == '__main__':
    main()
