#SingleInstance, Force
SendMode, Event
SetKeyDelay, 25, 10
SetWorkingDir, %A_ScriptDir%

global Enabled := True
global Active := False
global MaxIterations := 100

ToggleEnabled() {
    Enabled := !Enabled
}

Clamp(MinValue, MaxValue, CurrentValue) {
    Return Max(MinValue, Min(MaxValue, CurrentValue))
}

ApplyEnergy(Sys = 0, Eng = 0, Wep = 0) {
    If (!Enabled Or Active) {
        Return
    }
    Active := True

    Total := Sys + Eng + Wep
    If (Total != 6) {
        Return
    }

    CurrentSys := 2.0
    CurrentEng := 2.0
    CurrentWep := 2.0
    Iterations := 1

    Send, {Down}

    Iterate:
        ; SYS
        Loop {
            If (CurrentSys == Sys Or Sys < CurrentSys) {
                Break
            }

            IsHalfEng := CurrentEng - Eng == 0.5
            IsHalfWep := CurrentWep - Wep == 0.5
            If (IsHalfEng == True And IsHalfWep == True) {
                IsHalfEng := False
                IsHalfWep := False
            }

            CurrentSys := Clamp(0, 4, CurrentSys + 1.0)
            If (!IsHalfWep) {
                CurrentEng := Clamp(0, 4, CurrentEng - 0.5)
            }
            If (!IsHalfEng) {
                CurrentWep := Clamp(0, 4, CurrentWep - 0.5)
            }

            Send, {Left}
        }

        ; ENG
        Loop {
            If (CurrentEng == Eng Or Eng < CurrentEng) {
                Break
            }

            IsHalfSys := CurrentSys - Sys == 0.5
            IsHalfWep := CurrentWep - Wep == 0.5
            If (IsHalfSys == True And IsHalfWep == True) {
                IsHalfSys := False
                IsHalfWep := False
            }

            If (!IsHalfWep) {
                CurrentSys := Clamp(0, 4, CurrentSys - 0.5)
            }
            CurrentEng := Clamp(0, 4, CurrentEng + 1.0)
            if (!IsHalfSys) {
                CurrentWep := Clamp(0, 4, CurrentWep - 0.5)
            }

            Send, {Up}
        }

        ; WEP
        Loop {
            If (CurrentWep == Wep Or Wep < CurrentWep) {
                Break
            }

            IsHalfSys := CurrentSys - Sys == 0.5
            IsHalfEng := CurrentEng - Eng == 0.5
            If (IsHalfSys == True And IsHalfEng == True) {
                IsHalfSys := False
                IsHalfEng := False
            }

            If (!IsHalfEng) {
                CurrentSys := Clamp(0, 4, CurrentSys - 0.5)
            }
            If (!IsHalfSys) {
                CurrentEng := Clamp(0, 4, CurrentEng - 0.5)
            }
            CurrentWep := Clamp(0, 4, CurrentWep + 1.0)

            Send, {Right}
        }

        Iterations := Iterations + 1
        If (Iterations >= MaxIterations) {
            Goto, Done
        }

        If (CurrentSys != Sys Or CurrentEng != Eng Or CurrentWep != Wep) {
            Goto, Iterate
        } Else {
            Goto, Done
        }

    Done:
        Active := False
        Return
}