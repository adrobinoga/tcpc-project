#! /usr/bin/python2.7

import sys
import os.path

filename = sys.argv[1]
f = open(filename, 'r')

lines = f.readlines()
for k in range(len(lines)):

    tester_insts = ""
    l = lines[k]

    if "I2C.WRITE" in l:
        print "linea ", k, " :", l
        print "MACRO", l[ l.find("(")+1 : l.find(")")]

        # parse macro parameters
        params = l[l.find("(")+1: l.find(")")].split(",")

        # parse device address and RW bit
        addrprw = bin(int(params[0].strip(), 16))[2:].zfill(8)
        addr = addrprw[:-1]
        rwb = addrprw[-1]

        # parse data to write
        data_bytes = params[1].split(" ")

        # parse delay
        udelay = "\n\t\t#"+params[2].strip()

        # generate start condition
        tester_insts += "\n\t\t// START CONDITION"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"

        # write address
        n=0
        for b in addr:
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=0;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SDA=" + b + "; // addres bit " + str(n)
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
        tester_insts += "\n\t\t" + "SDA=0; // RW bit "
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

        # disconnect for ack
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1'hz;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

        # write bytes
        for d in data_bytes:
            if d:
                d = bin(int(d, 16))[2:].zfill(8)
                print "Write byte:", d

                n = 0
                for b in d:
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=0;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SDA=" + b + "; // data bit " + str(n)
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=1;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SCL=0;"
                    tester_insts += udelay
                    tester_insts += "\n\t\t" + "SDA=0;"
                    n += 1

                # disconnect for ack
                tester_insts += udelay
                tester_insts += "\n\t\t" + "SCL=0;"
                tester_insts += udelay
                tester_insts += "\n\t\t" + "SDA=1'hz;"
                tester_insts += udelay
                tester_insts += "\n\t\t" + "SCL=1;"
                tester_insts += udelay
                tester_insts += "\n\t\t" + "SCL=0;"
                tester_insts += udelay
                tester_insts += "\n\t\t" + "SDA=0;"

        # generate stop condition
        tester_insts += "\n\t\t// STOP CONDITION"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

        lines[k] = tester_insts

f = open(os.path.join(os.path.dirname(filename), "tester_generated.v"), 'w')
f.writelines(lines)
f.close()


