store byte stores lowest byte in register
offset basically shifts it up (preserves old values)

store word can be stored unaligned (?) in simulator, verify this is actually allowed in docs (would be tricky to implement)

load byte basically masks/shifts down the byte you want

l[whb] all use the same opcode (0000011b). They are delineated with `funct3`:
- 000b for byte
- 001b for half
- 010b for word
- 100 for BU (byte unsigned?)
- 101 for HU (half unsigned?)

I wonder how it looks for the 64-bit extension. 
I guess there's still 110 and 111... maybe they use a different opcode, though. :shrug:

