#Include, core.ahk

CapsLock::ToggleEnabled()

#If Enabled
1::ApplyEnergy(4, 0, 2)
2::ApplyEnergy(2, 4, 0)
3::ApplyEnergy(3, 0, 3)