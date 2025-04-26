# Alphanumeric Display Modification and Encryption System

This project is an **Alphanumeric Display and Encryption System** implemented on the DE10-Standard FPGA development board. The system allows users to input, modify, encrypt, and decrypt alphanumeric characters displayed across six seven-segment displays using VHDL and Verilog. Key functionalities include mode switching, ASCII input via switches, Caesar Cipher encryption/decryption, and real-time display control.

## Demo (In development)

_System Demo #1: Changing Displays_

<img src="/img/changing_displays.gif" alt="System Demo #1: Changing Displays" width="50%" />

## Features

### **Core Functionality**

- **Four Operating Modes**:

  - **View Mode (SW9=0, SW8=0)**: Static display of stored characters on HEX[5:0]
  - **Modify Mode (SW9=0, SW8=1)**: Edit characters using 8-bit ASCII input via SW[7:0]
    - Cycle through displays using KEY3
    - Active display flashes at 2Hz for visual feedback
  - **Encryption Mode (SW9=1, SW8=0)**: Shows Caesar-shifted characters
  - **Decryption Mode (SW9=1, SW8=1)**: Shows reverse-shifted characters

- **Caesar Cipher System**:
  - Adjustable shift value (0-255) using KEY1 (increment) and KEY2 (decrement)
  - Reset to 0 with KEY0
  - Current shift amount displayed on LEDs[7:0] in binary
  - Supports:
    - Digits (0-9): Wraps within 0-9 range
    - Uppercase letters (A-Z): Wraps within A-Z range
    - Lowercase letters (a-z): Wraps within a-z range

### **Technical Implementation**

- **VHDL Components**:

  - `ascii_to_seven_segment`: Converts 8-bit ASCII to 7-segment patterns
  - `clock_divider`: Generates 2Hz clock for display flashing
  - `shift_counter`: Manages Caesar shift value with button controls
  - `button_logic`: Debounces button inputs (KEY0-3)
  - `state_type_pkg`: Defines system modes (VIEW/MODIFY/ENCRYPT/DECRYPT)

- **Verilog Components**:

  - `encrypt`: Applies Caesar shift to ASCII characters
  - `decrypt`: Reverses Caesar shift on ASCII characters

- **FPGA Resources**:
  - Inputs: SW[9:0] (mode/ASCII), KEY[3:0] (controls), 50MHz clock
  - Outputs: HEX[5:0] (7-seg displays), LED[7:0] (shift value)

## System Architecture

### **Overall System Diagrams**

- **High-Level System Block Diagram**  
  <img src="/img/Overall System Block Diagram.png" alt="Complete System Block Diagram" width="80%" />

- **State Machine Diagram**  
  <img src="/img/State Machine System Block Diagram.png" alt="State Transition Diagram" width="80%" />

### **Mode-Specific Diagrams**

#### View Mode

- **Functional Overview**  
  <img src="/img/View Mode Functionality.jpg" alt="View Mode Functionality" width="80%" />
- **Block Diagram**  
  <img src="/img/View Mode System Block Diagram.png" alt="View Mode Architecture" width="80%" />

#### Modify Mode

- **Functional Overview**  
  <img src="/img/Modify Mode Functionality.jpg" alt="Modify Mode Functionality" width="80%" />
- **Block Diagram**  
  <img src="/img/Modify Mode System Block Diagram.png" alt="Modify Mode Architecture" width="80%" />

#### Encryption Mode

- **Functional Overview**  
  <img src="/img/Encryption Mode Functionality.jpg" alt="Encryption Mode Functionality" width="80%" />
- **Block Diagram**  
  <img src="/img/Encryption Mode System Block Diagram.png" alt="Encryption Mode Architecture" width="80%" />

#### Decryption Mode

- **Functional Overview**  
  <img src="/img/Decryption Mode Functionality.jpg" alt="Decryption Mode Functionality" width="80%" />
- **Block Diagram**  
  <img src="/img/Decryption Mode System Block Diagram.png" alt="Decryption Mode Architecture" width="80%" />
