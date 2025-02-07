# Alphanumeric Display Modification and Encryption System

This project is an **Alphanumeric Display Modification and Encryption System** implemented on the DE10-Standard FPGA development board. The system allows users to input, modify, and encrypt alphanumeric characters displayed across six seven-segment displays using VHDL. Key functionalities include mode switching, ASCII input via switches, Caesar Cipher encryption, and real-time display control.

## Demo (In development)

_System Demo #1: Changing Displays_

<img src="/img/changing_displays.gif" alt="System Demo #1: Changing Displays" width="50%" />

## Features

### **Core Functionality**

- **Mode Control**:
  - **View Mode (SW8=0)**: Static display of stored characters on HEX[5:0].
  - **Modify Mode (SW8=1)**: Edit characters using 8-bit ASCII input via SW[7:0]. Cycle through displays using KEY3.
  - **Flashing Indicator**: Active display flashes at 2 Hz in Modify Mode.
- **Encryption (SW9=1)**:
  - **Caesar Cipher**: Apply shifts to ASCII values with wrap-around logic.
  - **Shift Control**: Increment shift value with KEY1, reset to 0 with KEY0. Current shift amount displayed on LEDs[7:0] in binary.
- **Input/Output**:
  - **ASCII Input**: SW[7:0] for 8-bit character entry.
  - **Display Output**: Six 7-segment displays (HEX[5:0]) for alphanumeric output.
  - **LED Feedback**: LEDs[7:0] show the active Caesar shift value.

### **Technical Implementation**

- **VHDL Components**:
  - `seven_segment_to_ascii`: Converts 8-bit ASCII to 7-segment patterns.
  - `clock_divider`: Generates a 2 Hz clock for flashing displays in Modify Mode.
  - `shift_counter`: Manages Caesar Cipher shift value and LED output.
  - `button_logic`: Debounces button inputs (KEY0, KEY1, KEY3).
- **FPGA Resources**: Utilizes switches, buttons, 7-segment displays, LEDs, and the 50 MHz system clock.

## Project Status

### **Implemented**

- Mode switching (View/Modify/Encryption).
- ASCII-to-7-segment decoding for 0-9, A-Z, a-z.
- Caesar Cipher shift counter with LED feedback.
- Display cycling and flashing in Modify Mode.

### **In Progress**

- **7-Segment-to-ASCII Conversion**: Resolving ambiguities (e.g., '5' vs '8' mappings).
- **Encryption Logic**: Finalizing Caesar Cipher wrap-around for alphanumeric ranges.
  - **Current Focus**: Implementing the encryption module to handle shifts for both numeric (0-9) and alphabetic (A-Z, a-z) characters.
- **State Stability**: Implementing finite state machines (FSMs) to prevent mode-switching errors.
