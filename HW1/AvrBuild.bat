@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\AZ_Rezpar\HW1\labels.tmp" -fI -W+ie -C V2E -o "D:\AZ_Rezpar\HW1\HW1.hex" -d "D:\AZ_Rezpar\HW1\HW1.obj" -e "D:\AZ_Rezpar\HW1\HW1.eep" -m "D:\AZ_Rezpar\HW1\HW1.map" "D:\AZ_Rezpar\HW1\HW1.asm"
