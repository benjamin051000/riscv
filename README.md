# riscv-business
I want to learn about computer architecture by implementing a fully-functional RISC-V microprocessor. I'm not entirely sure what the end-goal will be here, but the overarching goal is to explore these concepts hands-on via real-world implementations.

# Roadmap
| Milestone | Status |
| - | - | 
| Turing complete | ✅ Done |
| RV32I | 🛠️ in progress | 
| RV32G (RV32IMAFD) | 📋 planned | 
| Canonical pipeline | 📋 planned | 
| Privileged instruction set | 📋 planned |
| Boot Linux | 📋 planned |
| Boot custom OS | 📋 planned |
| Graphical interface | 📋 planned |
| GPIO, serial interfaces | 📋 planned |
| UVM-based verification | 📋 planned |
| Performance benchmarking | 📋 planned |
| Comparisons with other FOSS RISC-V projects | 📋 planned |
| Superscalar | 💡 idea | 
| Register renaming | 💡 idea |
| Branch prediction | 💡 idea | 
| out-of-order execution | 💡 idea |
| Vector extension | 💡 idea |
| Float extensions | 💡 idea |
| Other ISA extensions | 💡 idea |
| DRAM connection (MAX 10) | 💡 idea |
| Cache hierarchy | 💡 idea |
| Multicore | 💡 idea |

# Tech stack
- The RISC-V hart is written in SystemVerilog.
- I own a [DE10-Lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021) FPGA development board, which has an Altera [MAX 10](https://www.intel.com/content/www/us/en/products/details/fpga/max/10.html) FPGA. I plan on emulating the design on this device.
- Intel Quartus Prime for synthesis to the aforementioned device.
- Questa for simulation (but I'm open to other simulation tools)

# Screenshots
TODO some screenshots of the synthesized design would be neat here.

# Resources
- [RISC-V Official Spec](https://riscv.org/technical/specifications/)
- [ISA Cheat Sheet](https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf)
- [RISC-V Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs/)
