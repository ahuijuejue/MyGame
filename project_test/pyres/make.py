
import hashlib
import sys 
import os
import types
import json

def convert_args(args):
    i = 1
    theTable = {}
    while len(args) > i :
        if type(args[i]) is types.StringType:
            if args[i][0] == "-":
                if args[i+1][0] == "-":
                    theTable[args[i][1:]] = True
                    i = i + 1
                else:
                    theTable[args[i][1:]] = args[i+1]
                    i = i + 2
            else:
                i = i + 1
        else:
            i = i + 1
    return theTable

def convert_path(path):
    while path[-1] == " ":
        path = path[0 : -1]
    if path[-1] != "/":
        path = path + "/"
    return path

def chk_args(args):
    if not args.has_key("i"):
        print("not input")
        return False
    args["i"] = convert_path(args["i"])
    if not os.path.exists(args["i"]):
        print "not find input dir"
    
    return True

def read_ver_list():
    array = []
    fp = open("config", "r")
    if fp:
        while True:
            line = fp.readline()
            if line:
                line = line.strip()
                if len(line) > 0:
                    array.append(line)            
            else:
                break
    else:
        print "\nError:not find config file\n"

    fp.close()

    return array


def main():       
    

    print "\ndone.\n"

if __name__ == '__main__':
    args = convert_args(sys.argv)
    
    if not chk_args(args):
        exit(0)

    

    arr = read_ver_list()

    if len(arr) > 0:
        version = arr[-1]       
        outPath = convert_path(version)
        if os.path.exists(outPath):
            text = "error: is exists:" + outPath
            print text            
            exit(-1)

        os.system("python mk_flistmodel.py -i " + args["i"] + " -o " + outPath + " -ver " + version)
        
        lists = ""
        for x in arr:
            lists += x
            lists += ","
        idx = lists.rfind(",")
        lists = lists[:idx]
        print lists
        os.system("python ckflist.py -i " + args["i"] + " -o " + outPath + " -ver " + version + " -list " + lists)

    print "\ndone.\n"



