#! /usr/bin/python2.7

import sys

filename = sys.argv[1]
print sys.argv
f = open(filename, 'r')
n=0

tester_insts = ""

for l in f.readlines():

    n +=1

    if "I2C.WRITE" in l:
        print "linea ", n, " :", l
        print "MACRO", l[ l.find("(")+1 : l.find(")")]
        params = l[ l.find("(")+1 : l.find(")")].split(",")

        # parse address of device and RW bit
        addrprw = bin(int(params[0].strip(), 16))[2:].zfill(8)
        addr = addrprw[:-1]
        rwb = addrprw[-1]

        # parse data to write
        data_bytes = params[1].split(" ")

        # parse delay
        udelay = "\n\t\t#"+params[2].strip()

        # generate start condition
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

        # write address
        n=0
        for b in addr:
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=0;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SDA=" + b + "; // addres bit " + n
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=1;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=0;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SDA=0;"
            n += 1

        # write RW bit
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=" + rwb + "; // RW bit "
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

        # disconnect for ack
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1'hz;"

        # write bytes
        for d in data_bytes:
            if d:
                bin(int(d, 16))[2:].zfill(8)
                print "Write byte:", d

                n = 0
                for b in addr:
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=0;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SDA=" + b + "; // addres bit " + n
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=1;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=0;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SDA=0;"
                    n += 1

        # generate stop condition
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"


print tester_insts

