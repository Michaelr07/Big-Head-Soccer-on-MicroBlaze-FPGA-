# Big-Head-Soccer-on-MicroBlaze-FPGA-

## Project Overview
Big Head Soccer is a 2-player arcade-style game implemented as the final project for the Advanced Verilog course at Cal Poly Pomona. It runs entirely on an FPGA using a System-on-Chip (SoC) architecture composed of:
- Custom SystemVerilog hardware cores for sprite rendering, keyboard input, and audio.
- A MicroBlaze soft processor running C++ game logic compiled with Xilinx Vitis.
- VGA display output for graphics, and PS2 keyboard for real-time controls.

## Features
- 2-player keyboard control using PS2 input
- Smooth sprite animation rendered over VGA
- Collision detection between ball, players, and goals
- Custom audio system using ADSR envelopes and DDFS for:
  - Kick sounds
  - Countdown music
  - Goal effects
  - Victory tune

## Display Output
Resolution: 640x480 VGA

## Hardware Design (Vivado)
The hardware design for Big Head Soccer is implemented in SystemVerilog and built using Xilinx Vivado. It combines cores provided in the FPGA Prototyping by SystemVerilog Examples (Chu textbook) with custom-developed IP modules for game-specific functionality.

The design follows a SoC architecture, with a MicroBlaze soft processor handling game logic in C++ while hardware peripherals manage input, video, and sound output.

## Project Structure
All hardware design files are located in the /hardware/ directory and organized for integration with Vivado IP integrator.

## VGA Display System
The game display is rendered over 640x480 VGA output using a modified video controller based on the Chu textbook's design. Our modifications allow for layered rendering of:
- Background tiles or solid color
- Player 1 sprite
- Player 2 sprite
- Ball sprite
- Goal Post Sprites
- Text overlay (score, messages)

Rendering is handled in hardware, which pulls data from sprite ROMs and composites each pixel in real time. A frame buffer is used primarily for background and text.

## Sprite System
The sprite_engine supports:
- Per-sprite position (x, y)
- Directional flipping
- Pixel transparency (via masking)
- Multiple sprite layers (background, ball, players)
Sprites are stored in block RAM initialized from .mem files.

## PS2 Keyboard Interface
Each player controls their character using a PS/2 keyboard. A custom ps2_keyboard core decodes serial scan codes and maintains a current key state register. This register is memory-mapped and read by the MicroBlaze game logic.

Player 1: WASD, Space
Player 2: Arrow keys, Right Shift

Multiple key presses are supported through key state tracking.

## Audio Subsystem
To generate music and sound effects directly from the FPGA, two custom cores were integrated:

ADSR Core: Shapes amplitude of sound over time using Attack, Decay, Sustain, Release parameters.
DDFS Core: Generates tones over a 3-octave chromatic scale by controlling frequency word input.

Each sound (kick, goal, countdown, win) is initiated by the MicroBlaze writing specific control values to the sound cores through AXI-mapped registers.

AXI Integration
All peripherals—video, PS2 input, sound, and sprite control—are connected to the MicroBlaze using AXI-Lite interfaces. This allows the C++ game logic to:
- Poll input states (keyboards)
- Trigger sound effects
- Control sprite positions
- Update score and game state
