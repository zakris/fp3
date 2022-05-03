# Takes a line from program.txt and returns only the address
from audioop import add
from platform import machine
from sys import stdout

from sympy import N, assemble_partfrac_list

# TODO:
# Make a def that will run through the text file and grab/store all the labels (with correct addresses to match)
# The label check from the main should be able to be cut/pasted into here




# Get the address from the given line
def getAddress(line) :
    address = line.split()[0]
    return address

# Takes a line from program.txt and returns the instruction (mov, add, beq, etc)
def getInstruction(line) :
    if(line == "jmp"):
        instruction = line
    else :
        instruction = line.split()[0]
    return instruction

# Takes a line from program.txt and returns the operands in a list (r1, r2, imm, shamt, etc)
def getOperands(line) :
    # If there are operands, put them in the list
    operands = [line.split()[1]]
    # Since our j-type instructions only have 1 operand, I need to check to see if there are any more elements after 1 operand
    # to see if the instruction is an R-Type or I-Type
    if(len(line.split()) > 2) :
        operands.append(line.split()[2])
        operands.append(line.split()[3])
    return operands

# Convert integer to binary
def intToBin(num) :
    num = int(num)
    binary = format(num, 'b')
    return str(binary)

# Generate the Machine code for the instructions
def generateMachineCode(instruction, operands) :
    machineCode = ''
    assemblyTable = {
        # Instructions:
        'add'   : '0000',
        'sub'   : '0001',
        'sll'   : '0010',
        'srl'   : '0011',
        'movi'  : '0100',
        'beq'   : '0101',
        'bne'   : '0110',
        'and'   : '1001',
        'or'    : '1010',
        'slti'  : '1100',
        'slt'   : '1101',
        'jmp'  : '1011',
        'load'  : '0111',
        'store' : '1000',
        'bgz'   : '1110',
        # Registers:
        'r0'    : '0000',
        'ir1'   : '0001',
        'ir2'   : '0010',
        'pc'    : '0011',
        'fr'    : '0100',
        'r1'    : '0101',
        'r2'    : '0110',
        'r3'    : '0111',
        'r4'    : '1000',
        'r5'    : '1001',
        'r6'    : '1010',
        'r7'    : '1011',
        'r8'    : '1100',
        'r9'    : '1101',
        'r10'   : '1110',
        'r11'   : '1111',
    }
    # If the instruction is jmp type, just grab the machine code and return/leave
    if instruction == 'jmp':
        machineCode += assemblyTable[instruction]
        return machineCode
    # All other instructions are handled here
    machineCode += assemblyTable[instruction]
    machineCode += assemblyTable[operands[0]]

    # for testing purposes.
    dict_operand = {}
    if(len(operands) > 1) :

        # loop to find operand value in look-up table and gen hex
        vars_2 = operands[0]
        machineCode += assemblyTable[vars_2]

        if(operands[2].isdigit()) :
            machineCode += intToBin(operands[2])
        else :
            machineCode += assemblyTable[operands[2]]
    return machineCode

# Program Start #
# Read .txt file and put each line of the file into 'line' as a list
with open('assembler/program.txt') as f:
    lineWithEmptySpace = []  # this list will have empty space from txt
    line = [] # this will hold the lines without any whitespace whatsoever, filtered from the other list
    for l in f : # check each line for comments both in the line or a whole line comment
        l = l.split('#', 1)[0]
        lineWithEmptySpace.append(l.rstrip())
    line = list(filter(None, lineWithEmptySpace))
        
ProgCount = 0

fileOutput = open("hexMachineCode.dat", "w")
i = 0
dataField = False
dataMemoryAdress = 0
varSize = 0
address = 0
LabelAddress = {} # handles labels in the instructions.
symbols = {} # serves as a loop-up table for the variables used in the program.
index = 0 # used for memory address of variables. 
variables = {} # store variables from .asm
print("Instructions Parsed: ", line)
for x in line : # for each index in line
    labelCheck = False
    # if(len(line[i].split()) <= 1) :
    #     break
    # if(line.__contains__(":")):
    #     z = line.split(':',1)[0]
    if(x != '\n'):
        if(x.split()[0] == '.variables'):
            dataField = True
        elif(x.split()[0] == '.instructions'):
            dataField = False 
        #    address = 0   
        elif dataField: # store variables in list
            _name, _type,_value = x.split(' ') 
            variables[_name] = _type + ','+ _value

            # storing memory address
            symbols[_name] = 4*index
            index +=1

            print('variable handling here')
        else:
            #label check
            #if label check is true jump to where label is defined might need another for loop here to do so
            # nextHexCode = getAddress(line[i]) # nextHexCode will hold the address of any given line
            if(line[i].split()[0] == "jmp"):
                nextInstruct = getInstruction("jmp")
                instructionReg = generateMachineCode(nextInstruct, 0)
                nextOperands = getOperands(x)
               # instructionReg += str(format(LabelAddress[nextOperands[0]], 'b'))
                instructionReg += LabelAddress[nextOperands[0]]
                instructionReg = hex(int(instructionReg, 2))
                instructionReg_trunc = instructionReg[2:]
            elif  x.__contains__(':'): # when encounter's label.
                labelCheck = True
                addressToAdd = address+4
                addressAsString = str(format(addressToAdd, 'b'))
                labelName= x.split(':')[0] # get label name
                lengthOfAddress = len(str(format(addressToAdd,'b')))
                testx =addressAsString.zfill(12)
                # if(lengthOfAddress < 15):
                #     #lengthTest = len(str(format(LabelAddress[nextOperands[0]], 'b')))
                #     noOfZeros = 15 - lengthOfAddress
                #     for inc in range(1, noOfZeros-1):    
                #          addressAsString += "0"
                LabelAddress[labelName] = testx
            else : #rest of instructions
                nextInstruct = getInstruction(line[i]) # nextInstruct will hold which instruction is happening (mov, add, etc)
                nextOperands = getOperands(line[i]) # nextOperands is a list of registers/labels in use (r1, r2, label, etc)
                instructionReg = generateMachineCode(nextInstruct, nextOperands)
                #instructionReg = generateMachineCode(nextInstruct, nextOperands)
                instructionReg = hex(int(instructionReg, 2))
                instructionReg_trunc = instructionReg[2:].zfill(4)# Truncate 0x from the hex string.
          
            #instructionReg = hex(int(instructionReg_trunc, 2)) # assign to instructionReg
            if(labelCheck == False):
                print(instructionReg_trunc)
                if(x == line[-1]): #if last line, don't add a new line character to hexcode
                    fileOutput.write(instructionReg_trunc)
                else:
                    fileOutput.write(instructionReg_trunc+'\n')
                
    i += 1
    address += 4
    hex(address)
fileOutput.close()



# DataMemoryAddressOfInstruction = 0
# for()
# set DataMemoryAddressOfInstruction = 0
# for each variable definition at the top of the program 
#     # (these are variables that will be stored in memory
#     Determine the size of memory required for that variable.

#     # Insert a { name : (DataMemoryAddressOfInstruction, size) } key value pair 
#     # into a dictionary i.e. use the name as an index (key) to store the assigned 
#     # memory address of the variable along with the number of bytes the variable requires.

#     # Given the size of the first variable encountered, 
#     # compute the memory address location for the next variable. 
#     DataMemoryAddressOfInstruction += size

# set MemoryAddressOfInstruction = 0
# for each line of assembly language: 

#     set NextHexCode = ""
    
#     # Strip comments from the line of code read 

#     if line of assembly language code has a label :  

#         Store MemoryAddressOfInstruction in a dictionary indexed by the label

#         Determine the assembly language keyword on the line of code 

#         Based on assembler keyword update NextHexCode contents

#     if line of code has arguments : 

#         Based on argument types (register, variable, immediate) 
#         and instruction type update NextHexCode 

#     print NextHexCode to the output machine code file. 

#     # Update the memory Address
#     MemoryAddressOfInstruction += Size of Instruction Just Processed
