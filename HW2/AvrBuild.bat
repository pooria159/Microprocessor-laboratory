@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\AZ_Rezpar\HW2\labels.tmp" -fI -W+ie -C V2E -o "D:\AZ_Rezpar\HW2\HW2.hex" -d "D:\AZ_Rezpar\HW2\HW2.obj" -e "D:\AZ_Rezpar\HW2\HW2.eep" -m "D:\AZ_Rezpar\HW2\HW2.map" "D:\AZ_Rezpar\HW2\HW2.asm"
