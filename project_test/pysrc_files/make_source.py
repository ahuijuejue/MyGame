
import sys 
import os
import json
import types

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

def read_config():    
    fp = open("make_source_cfg", "r")
    if fp:
        cfg = json.load(fp)
        fp.close()
        return cfg
    else:
        print "\nError:not find config file\n"
        fp.close()

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
    
def main():
    args = convert_args(sys.argv)
    cfg = read_config()
    if not cfg:
        exit(1)

    input = cfg["input"]
    version = args["ver"]
    # version = cfg["version"]
    output = version + cfg["output"]    

    exclude = cfg["exclude"]
    compile_scripts = cfg["compile_scripts"] 

    if os.path.exists(version):
        text = "error: is exists:" + version
        print text            
        exit(-1)

    # input = convert_path(input)
    chk_path(output)

    exStr = ""
    if len(exclude) > 0:
        exStr += " -x "
        for x in exclude:
            exStr += x
            exStr += ","
        idx = exStr.rfind(",")
        if idx >= 0:
            exStr = exStr[:idx]

    sysStr = "sh " + compile_scripts + " -i " + input + " -o " + output + exStr 
    if cfg.has_key("e"):
        sysStr = sysStr + " -e " + cfg["e"] + " -ek " + cfg["ek"]

    if cfg.has_key("es"):
        sysStr = sysStr + " -es " + cfg["es"]

    if cfg.has_key("m"):
        sysStr = sysStr + " -m " + cfg["m"]

    os.system(sysStr)

    # os.system("python ./mkflist.py " + output + " " + version)

if __name__ == '__main__':
    main()
