
import sys 
import os
import json

def read_config():    
    fp = open("config", "r")
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
    cfg = read_config()
    if not cfg:
        exit(1)

    input = cfg["input"]
    output = cfg["version"] + cfg["output"]
    version = cfg["version"]
    exclude = cfg["exclude"]
    compile_scripts = cfg["compile_scripts"] 

    if os.path.exists(version):
        text = "error: is exists:" + version
        print text            
        exit(-1)

    input = convert_path(input)
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

    os.system(sysStr)

    os.system("python ./mkflist.py " + output + " " + version)

if __name__ == '__main__':
    main()
