from ctypes import Structure

with open('assembler/program.txt') as f:
    lineWithEmptySpace = []  # this list will have empty space from txt
    line = [] # this will hold the lines without any whitespace whatsoever, filtered from the other list
    for l in f : # check each line for comments both in the line or a whole line comment
        l = l.split('#', 1)[0]
        lineWithEmptySpace.append(l.rstrip())
    line = list(filter(None, lineWithEmptySpace))



listA = [] #variables list
listB = [] #instructions list
for x in line :
  listA.append(x)

n,e = 0,0
for i in range(0, len(listA)): 
    if listA[i] == '.variables': n = i
    if listA[i] == '.instructions': e = i

_var = listA[n+1:e] # variables codes
_instructions = listA[e+1:len(listA)] # instructions codes
address = 0

#print(_var) # test variable codes. 
variables = {}

# obtain the variables 
for i in _var: 
    
    _name, _type, _value = i.split(' ') 
    variables[_name] = _type + ',' + _value


print(variables)


# Get Program Counter/address value of Labels. 
LabelAddress= {}  # dictionary to store label address. 

for instr in _instructions:
    
    if instr.__contains__(':'): # when encounter's label.
        labelName= instr.split(':')[0] # get label name
        LabelAddress[address] = labelName
        
        
    address += 4
    hex(address)

# 
    


    
