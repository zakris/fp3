# CS401-1 Digital Design and Computer Architecture
## FP3: Control Unit Design

# Introduction    
In this lab you will design the main *Control Unit (CU)* for your processor.  The goal of this lab will be to design a CU that correctly interprets and executes your machine code instructions that you designed in FP1. Recall that an instruction is fetched from memory, and, the control unit recieves the **instruction opcode** signal bits of the current instruction. Typically, the current instruction that is executing is held steady in an **Instruction Register** and the opcode bits from this register connect to the CU. Based on the instruction, the CU outputs appropriate control signals that tell each indvidual component of the DPU exactly what to do (and when to do it).  A CU controls the "Decode" and "Execute" phases of an instruction's life-cycle.  

# Single-cycle or Multi-cycle Machine?
Single-cycle machines have much simpler control units than multi-cycle machines. A multi-cycle machine requires a finite state machine control unit, while in contrast, a single-cycle machine only requires a simple "decoder" as we saw in the MIPS single-cycle processor design.

* In a *single-cycle machine*, the control unit is just a fancy *look-up ROM* that acts somewhat like a python dictionary or a C++ map.  The instruction op-code functions serves as the input "key" and the control unit then returns the "value" (i.e. the set of control signals sent to the control bus) that control each component in the DPU. The *control bus* consists of the set of wires that carry control signals from the CU to each component in the Data Path Unit (DPU). Each instruction's opcode will result in a specific set of control signals that cause the components in the DPU to behave in a manner appropriate to the instruction currently being executed.

* In a *multi-cycle machine*, the control unit is built using a *finite state machine (FSM)*.  In this case, each instruction op-code triggers the FSM to proceeds through a series of control states. Each control state is associated with a specific set of control signals that are activated during that control state. All of the instruction share the same "fetch" control state of the FSM, but, after decoding, each individual instruction will step through a specific set of control states required to execute that instruction. Each individual control state will then result in a specific set of control signals that will in turn, cause the components in the DPU to execute all the operations required for the given instruction. Some instructions will require more control states than others and thus take longer to execute.

# 25 pts. Exercise 1: Control Unit (CU) Design
The controller is the portion of the CU that looks at the opcode and determines the output signals. As described above, it is a map that links instructions to the activation of the appropriate control signals for that instruction.  Have your Assembly Language, ALU, and DPU designs easily accessible while you work on this design. 

Choos if you group will designing a single cycle or multi-cycle machine. Complete the appropriate table for the type of machine you are designing.

#### SINGLE CYCLE CU DESIGN:  
Complete this section if you are doing a single cycle processor. 

Create a table in Fig. 1 with one row for each of your instructions. You can see Table 7.3 on page 384 for an example of what this might look like for your processor.  Basically this is just a simply a list of opcodes followed by all the control signals activated for those opcodes. You have already seen a table like this in the MIPS projects. Use as many columns as needed for your control signals.

*********************************************************************
Fig. 1 Single Cycle CU Main Decoder Truth Table
*********************************************************************

#### MULTI CYCLE CU DESIGN: 
Complete this section if you are making a multi-cycle CPU. Modify or make your own FSM design language similar to the FSM pseudo-code is shown below in Fig 1 Multi-Cycle. 
The code shown here is not VHDL, but a simple language that describes a FSM. 

*********************************************************************

```
    FETCH:   
            IM_READY <= '1'                           # Read from instruction memory
            WAIT:  WHILE IM_READY != '1' GOTO WAIT:   # wait for memory ready signal
            INSTRUCTION_REG <= MEMORY_OUT_BUF         # Load instruction register
            GOTO DECODE:

    DECODE: 
            OPCODE <= INSTRUCTION_REG( x downto y )   # Get Opcode from INSTRUCTION_REG 
            NEXT_STATE <= CU[ OPCODE ]                # Lookup NEXT_STATE in the Control Unit
            GOTO NEXT_STATE:                          # Execute Next State for instruction

#  THE STATE MACHINES FOR EACH INSTRUCTION

    LW :
            State 1 of LW set signals
            State 2 of LW set signals
            :         :
            GOTO FETCH:
    
    SW :    
            State 1 of SW set signals
            State 2 of SW set signals
            :         :
            GOTO FETCH:

    ADD:    
            Set signals for the ALU to ADD
            Set signals to take output from ALU 
            Set signals to put output it where it belongs
            GOTO FETCH:
```
Fig 1 Multi-cycle FSM Decode
*********************************************************************

## 25 pts. Exercise 2: Integrated VHDL for the Control Unit and the Data Path Unit
Using the tables or FSM from Exercise 1 to design the VHDL for your processor's Control Unit and itegrate the CU and control signals into your DPU. 

### SINGLE CYCLE CONTROL UNIT DESIGN:  
For an example, look at the MIPS single cycle control unit. The VHDL is on pages 431, 432 of the textbook, you can also look at MIPS3 for example VHLD code for the control unit.

### MULTI-CYCLE CONTROL UNIT DESIGN:  
For this, you will want to refresh your memory on how to write code for a **Finite State Machine**. See pages 212 and 213 in your textbook.  The main idea here is that you can design a control unit FSM using the concept of "microcode".  Microcode is like a mini-assembly/finite state machine language that you can lay out as shown above. It's just a psuedo code textual description of the FSM bubbles like those that are shown on pages 212, 213 of your textbook.

## 25 pts. Exercise 3:  VHDL Testbench With a Simple Ad-hoc Test Program Running Correctly
Design a very simple ad-hoc test program for your processor. This should test **every instruction** you intend for it to execute.  Remember, you will need to put the hex code into a data file that can be read by your VHDL code. 

* Make sure it is working in simulation before attempting to run in the FPGA
* IMPORTANT: Every time you change your hexcode file contents, you will need to re-run the gen.sh script in order to incorporate the hex file for the instructions into the memory of the machine.
* Use the correct case for the hexcode file!
* Verify that each instruction is working as intended. 

## 25 pts. Exercise 4: Mini Presentation FP3
1. Show the class your control unit design. If you have a multi-cycle, you must show your bubble diagram state machine diagram. For a single-cycle machine you must show your decoder tables.
2. Demo your ad-hoc program running (either in simulation or on the FPGA). 
3. What hardware bugs did you encounter in testing? How did you find them? How did you squash them?
4. Did you go above and beyond the assignment requirements in any way?


## What to Hand In
This document with the following items included. 
* VHDL code for your completed design the FP3 subfolder of your group's whitgit repository
* List of instructions and op-codes.
* SINGLE-CYCLE: Neatly drawn decoder tables.
* MULTI-CYCLE: Neatly drawn FSM bubble diagram and/or microcode table/spreadsheet for the multi-cycle design. 
* jpg/png files that demonstrate your microprocessor is running the ad-hoc program correctly.

### Summary of Observations
In this section, include your summary of the groups observations.  

| CATEGORY |  Beginning 0%-79% | Satisfactory 80%-89% | Excellent 90%-100% |
|:--------:|:-----------:|:------------:|:----------:|
| 25 pts. Control Unit Design | Rudimentary decoder tables. | Basic decoder tables and/or basic finite state machine bubble diagram for the control unit. | Neat, well commented, complete set of decoder tables (single cycle)  or neat, well commented complete finite state machine bubble diagram and tables  (multi-cycle). |
| 25 pts. Control Unit VHDL | VHDL code for the control unit. Few to no comments. | Some instructions working, satisfactory VHDL code for the control unit. Satisfactory comments. | Working VHDL code for all the instructions in the control unit. Excellent comments, code formatted neatly, etc. |
| 25 pts. Control Unit Test  | Simulation test bench created but not documented well or does not work properly |	Ad-hoc test code that tests every possible instruction and runs correctly in simulation. |	Ad-hoc program that runs correctly in simulation and also on the FPGA. |
| 25 pts. Mini Presentation | Little to no content, poor presentation. | Several of the required elements for Exercise 4 | All the required elements of Exercise 4 and a good presentation.

