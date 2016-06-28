
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


def chk_path(path):    
    path = os.path.dirname(path)    
    idx = path.rfind("/")
    spath = ""
    if idx >= 0:
        spath = path[:idx + 1]
    
    if idx < 0:         
        if not os.path.exists(path):
            print "make:", path
            os.mkdir(path)

        return True
    elif chk_path(spath):        
        if not os.path.exists(path):
            print "make:", path
            os.mkdir(path)

        return True
    else:
        return False

def chk_args(args):
    if not args.has_key("i"):
        print("not input")
        return False
    args["i"] = convert_path(args["i"])
    if not os.path.exists(args["i"]):
        print "not find input dir"

    if not args.has_key("list"):        
        return False
    args["list"] = args["list"].split(",")

    if not args.has_key("o"):
        print("not output")
        return False
    args["o"] = convert_path(args["o"])
    if not os.path.exists(args["o"]):
        chk_path(args["o"])
    if not os.path.isdir(args["o"]):
        print("output must be dir")
        return False
    if not args.has_key("ver"):
        print("please enter version: -ver")
        return False

    return True

def convert_arr_2_list(arr):
    rtn = {}
    for x in arr:
        key = x["path"] + x["name"]
        rtn[key] = x
    return rtn


def compare_ver(ver1, ver2):
    file1 = ver1 + "/flistmodel"
    file2 = ver2 + "/flistmodel"

    print "file1:" + file1
    print "file2:" + file2

    if not os.path.isfile(file1):
        print ("not find", file1)
        return False

    if not os.path.isfile(file2):
        print ("not find", file2)
        return False

    fp = open(file1, "rb")
    cfg1 = json.load(fp)
    fp.close()

    fp = open(file2, "rb")
    cfg2 = json.load(fp)
    fp.close()

    opt1 = convert_arr_2_list(cfg1["stage"])
    opt2 = convert_arr_2_list(cfg2["stage"])

    for x in opt2:
        if opt1.has_key(x) and opt1[x]["code"] == opt2[x]["code"]:
            continue
        configs[x] = opt2[x]

    return True

def str_config():
    buf = "local list = {\n\tver = \"" + args["ver"] + "\",\n\tstage = {\n"
    for key in configs:
        config = configs[key]
        buf += "\t\t{name=\"" + config["name"] + "\", code=\""
        buf += config["code"] + "\", act=\"load\", size="
        buf += str(config["size"]) + ", path=\""
        buf += config["path"] + "\"},\n"
    buf += "\t},\n\tremove={\n\t},\n}\nreturn list"
    return buf

def cpy_by_config(configs):
    for key in configs:
        cfg = configs[key]
        topath = save_path + cfg["path"]
        print "to path:", save_path
        if not os.path.exists(topath):
            chk_path(topath)
        frompath = args["i"] + cfg["path"]
        if not os.path.exists(frompath + cfg["name"]):
            print "not find file:", frompath + cfg["name"]
            return False
        fp = open(frompath + cfg["name"], "rb")
        if not fp:
            print "not open file:", frompath + cfg["name"]
            return False
        readstr = fp.read()
        fp.close()

        fp = open(topath + cfg["name"], "w+")
        if not fp:
            print "not open write file:", topath + cfg["name"]
            return False
        fp.write(readstr)
        fp.close()

        print "from:" + frompath + cfg["name"] + " to====: " + topath + cfg["name"]
        
    return True

def main(): 
    if len(args["list"]) > 1:
        print "-------------------"
        print "compare configs"
        for x in xrange(0,len(args["list"])-1):
            if not compare_ver(args["list"][x], args["list"][x + 1]):
                exit(1)
        print "--------------------"
    
    str = str_config()
    
    print "write to file:" + save_path + 'flist'
    
    flist = open(save_path + 'flist', 'w+') 
    flist.write(str)
    flist.close()

    print("\ncopy resource.")
    if not cpy_by_config(configs):
        print "Error!"
        exit(1)

    print "\ndone.\n"

if __name__ == '__main__':
    args = convert_args(sys.argv)
    print args
    if not chk_args(args):
        exit(0)

    server_suffix = "ress/"
    save_path = args["o"] + server_suffix
    if not os.path.exists(save_path):
        chk_path(save_path)
     
    configs = {}

    main()



