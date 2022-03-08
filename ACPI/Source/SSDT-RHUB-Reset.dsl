/*
 * Force RHUB Reset on IceLake Platforms
 * Source: 
 * https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/decompiled/SSDT-RHUB-prebuilt.dsl
 */
DefinitionBlock ("", "SSDT", 2, "CORP", "RHBReset", 0x00001000)
{
    External (_SB_.PCI0.TXHC.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)

    If (_OSI ("Darwin"))
    {
        Scope (_SB.PCI0.TXHC.RHUB)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Scope (_SB.PCI0.XHC.RHUB)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }
    }
}

