# Alphanumeric Display Modification and Encryption System

This project is an **Alphanumeric Display Modification and Encryption System** designed for the DE10-Standard development board, using entirely VHDL for its implementation. The system enables users to input and modify alphanumeric characters displayed on six seven-segment displays, controlled through 8-bit ASCII input provided via switches.

## Demo (In development)

_System Demo #1: Changing Displays_

<img src="/img/changing_displays.gif" alt="System Demo #1: Changing Displays" width="50%" />

## Features

- **Alphanumeric Input**: The system accepts 8-bit ASCII values through a set of 8 switches (SW0–SW7), which are used to modify characters displayed on the seven-segment displays.
- **Display Control**: The displays are modified based on the current input, and users can navigate through each seven-segment display using push button KEY3.

## Planned Features

- **Encryption Control**: SW9 is reserved for enabling and controlling an encryption feature that will modify the displayed values. The encryption logic will be designed within VHDL.
- **Encryption**: A feature controlled by SW9 to apply an encryption algorithm on the input characters before displaying them.
- **All-VHDL Implementation**: The system logic, including the encryption and display modification, will be entirely implemented in VHDL.
- **Switch & Button Control**: Push buttons allow users to move between different segments and confirm the changes on each display.
- **Flashing Digit**: The selected digit will flash, indicating it is currently being modified.

## Development Plan

- **VHDL Development**: The entire project will be coded in VHDL, from the switch control to the seven-segment display logic and the encryption feature.

## Project Status

Currently in the development stage...
