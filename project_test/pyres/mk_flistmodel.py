
import hashlib
import sys 
import os
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
    if not os.path.isdir(args["i"]):
        print("input must be dir")
        return False
    args["i"] = convert_path(args["i"])

    if not args.has_key("o"):
        print("not output")
        return False
    args["o"] = convert_path(args["o"])
    if not os.path.exists(args["o"]):
        os.mkdir(args["o"])
    if not os.path.isdir(args["o"]):
        print("output must be dir")
        return False
    if not args.has_key("ver"):
        print("please enter version: -ver")
        return False


    return True

def hexstr(s):
    hs = ""
    for i in range(len(s)):
        hs += '%02X' % ord(s[i])
    return hs

def hex_dir(dir):
    if os.path.isdir(dir):
        files = os.listdir(dir)
        for file in files:
            if file[-4:] != ".svn":
                print file
                if os.path.isdir(dir + file):
                    hex_dir(dir + file + "/")
                elif os.path.isfile(dir + file):
                    hex_file(file, dir)

def hex_file(file, dir):      
    m = hashlib.md5()
    filePath = dir + file 
    print filePath
    if os.path.isfile(filePath):

        fp = open(filePath,'rb')
        print fp
        while True:
            blk = fp.read(4096) # 4KB per block
            if not blk: break
            hs = hexstr(blk)
            m.update(hs)
        fp.close()
        ms = m.hexdigest() 

        size = os.path.getsize(filePath)

        resPath = dir[len(args["i"]):]        
        config = {
            "path" : resPath,
            "file" : file,
            "code" : ms,
            "size" : str(size),
        }
        if config["file"][0:1] != ".":
            configs.append(config)

def str_config():
    buf = "{\n\t\"ver\" : \"" + args["ver"] + "\",\n\t\"stage\" : [\n"
    addBuf = ""
    for config in configs:
        addBuf += "\t\t{\"name\":\"" + config["file"] + "\", \"code\":\""
        addBuf += config["code"] + "\", \"act\":\"load\", \"path\":\""
        addBuf += config["path"] + "\", \"size\":"
        addBuf += config["size"] + "},\n"
    if len(addBuf) > 0:
        idx = addBuf.rfind(",")
        if idx >= 0:
            addBuf = addBuf[:idx]
            addBuf += "\n"
    buf += addBuf
    buf += "\t],\n\t\"remove\":[\n\t]\n}\n"
    return buf

def main():   
    hex_dir(args["i"])
    str = str_config()

    flist = open(args["o"] + 'flistmodel', 'w+') 
    flist.write(str)
    flist.close()

    print "\ndone.\n"

if __name__ == '__main__':
    args = convert_args(sys.argv)
    if not chk_args(args):
        exit(0)
     
    configs = []

    main()



