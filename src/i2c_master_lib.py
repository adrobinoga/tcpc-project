#! /usr/bin/python2.7

import sys
import os.path

def i2c_write_replace(l):
    """
    Genera instrucciones verilog para simular escrituras por parte del master
    :param l: Linea con parametros
    :return: Instrucciones verilog
    """

    tester_insts = ""

    # parse macro parameters
    # I2C.WRITE( (direccion del dispositivo << 1) + RWbit, bytes a escribir, tiempo entre cambios)
    params = l[l.find("(") + 1: l.find(")")].split(",")

    # parse device address and RW bit
    addrprw = bin(int(params[0].strip(), 16))[2:].zfill(8)
    addr = addrprw[:-1]
    rwb = addrprw[-1]

    # parse data to write
    data_bytes = params[1].split(" ")

    # parse delay
    udelay = "\n\t\t#" + params[2].strip()

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
    n = 0
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

    return tester_insts


def i2c_read_replace(l):
    """
    Genera instrucciones verilog para simular lecturas por parte del master
    :param l: Linea con parametros
    :return: Instrucciones verilog
    """
    tester_insts = ""

    # parse macro parameters
    # I2C.READ( (direccion del dispositivo << 1) + RWbit, numero de bytes a leer, tiempo entre cambios)
    params = l[l.find("(") + 1: l.find(")")].split(",")

    # parse device address and RW bit
    addrprw = bin(int(params[0].strip(), 16))[2:].zfill(8)
    addr = addrprw[:-1]
    rwb = addrprw[-1]

    # number of bytes to read
    nbytes = int(params[1])

    # parse delay
    udelay = "\n\t\t#" + params[2].strip()

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
    n = 0
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
    tester_insts += "\n\t\t" + "SDA=1; // RW bit "
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


    # read bytes
    for nb in range(nbytes):

        print "Read byte:", nb

        for m in range(8):
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SDA=1'hz;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=0;"
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=1;" + " // read bit " + str(m)
            tester_insts += udelay
            tester_insts += "\n\t\t" + "SCL=0;"

        # master ack
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        if nb == (nbytes - 1):
            tester_insts += "\n\t\t" + "SDA=1;"
        else:
            tester_insts += "\n\t\t" + "SDA=0;"

        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=1;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SCL=0;"
        tester_insts += udelay
        tester_insts += "\n\t\t" + "SDA=0;"

    # stop condition
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

    return tester_insts

# archivo a leer
filename = sys.argv[1]
f = open(filename, 'r')

# lee las lineas del archivo
lines = f.readlines()

# procesa el archivo linea por linea en busca de macros
for k in range(len(lines)):

    l = lines[k]

    # macro de escritura por parte del master
    if "I2C.WRITE" in l:
        print "Linea ", k, " :", l
        lines[k] = i2c_write_replace(l)

    # macro de lectura por parte del master
    if "I2C.READ" in l:
        print "Linea ", k, " :", l
        lines[k] = i2c_read_replace(l)

# almacena el resultado en tester_generated.v
f = open(os.path.join(os.path.dirname(filename), "tester_generated.v"), 'w')
f.writelines(lines)
f.close()


