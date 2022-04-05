/*
 * Screen on after wake (triggered by pressing power button / open the lid)
 * Credit to OC-Little
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "AOACWake", 0x00000000)
{
    External (_SB_.LID0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_._Q16, MethodObj)    // 0 Arguments

    If (_OSI ("Darwin"))
    {
        Scope (_SB.PCI0.LPCB)
        {
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                \_SB.PCI0.LPCB.EC0._Q16 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
            }
        }
    }
}

