/*
 * Enable PEPD under macOS for ThermalSolution.kext
 * to handle with S0 deep idle functions 
 */
DefinitionBlock ("", "SSDT", 2, "hack", "ECRW", 0x00000000)
{
    External (_SB_.PEPD, DeviceObj)

    If (_OSI ("Darwin"))
    {
        Scope (_SB.PEPD)
        {
            Name (OSYS, 0x07DC)
            Name (S0ID, One)
        }
    }
}

