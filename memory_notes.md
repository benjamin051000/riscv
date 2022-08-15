store byte stores lowest byte in register
offset basically shifts it up (preserves old values)

store word can be stored unaligned (?) in simulator, verify this is actually allowed in docs (would be tricky to implement)

load byte basically masks/shifts down the byte you want

