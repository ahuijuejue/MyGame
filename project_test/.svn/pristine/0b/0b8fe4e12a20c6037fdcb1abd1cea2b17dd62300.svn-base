
import hashlib
import sys 
import os
import types
import json

def read_source_config():    
    fp = open("make_source_cfg", "r")
    if fp:
        cfg = json.load(fp)
        fp.close()
        return cfg
    else:
        print "\nError:not find config file\n"
        fp.close()


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
    fp = open("version_cfg", "r")
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
    path_cfg = read_source_config()
    ver_list = read_ver_list()

    if len(ver_list) > 0:
        version = ver_list[-1]
        path_code = version + path_cfg["output"]
        path_source_base = path_cfg["input"]
        path_version = version


        path_version = convert_path(path_version)
        if os.path.exists(path_version):
            text = "error: is exists:" + path_version
            print text            
            exit(-1)

        os.system("python make_source.py -ver " + version)

        os.system("python mk_flistmodel.py -i " + path_code + " -o " + path_version + " -ver " + version)
        
        lists = ""
        for x in ver_list:
            lists += x
            lists += ","
        idx = lists.rfind(",")
        lists = lists[:idx]
        print lists
        os.system("python ckflist.py -i " + path_code + " -o " + path_version + " -ver " + version + " -list " + lists)

    print "\ndone.\n"



