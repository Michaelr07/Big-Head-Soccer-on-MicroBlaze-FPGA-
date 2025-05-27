# Big-Head-Soccer-on-MicroBlaze-FPGA-

##Project Overview
Big Head Soccer is a 2-player arcade-style game implemented as the final project for the Advanced Verilog course at Cal Poly Pomona. It runs entirely on an FPGA using a System-on-Chip (SoC) architecture composed of:
- Custom SystemVerilog hardware cores for sprite rendering, keyboard input, and audio.
- A MicroBlaze soft processor running C++ game logic compiled with Xilinx Vitis.
- VGA display output for graphics, and PS2 keyboard for real-time controls.

##Features
- 2-player keyboard control using PS2 input
- Smooth sprite animation rendered over VGA
- Collision detection between ball, players, and goals
- Custom audio system using ADSR envelopes and DDFS for:
- Kick sounds
- Countdown music
- Goal effects
- Victory tune

Full co-design of hardware (SystemVerilog) and software (C++) which are further described in their respective folders
