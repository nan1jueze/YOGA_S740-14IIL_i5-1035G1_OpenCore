/*   
 * Touchpad fix for Lenovo Yoga S740-14IIL (81RS/81RM)
 * Credit to frozenzero123
 * URL: https://github.com/frozenzero123/YOGA-S740
 * Special Thanks to bat.bat
 *
 * DSDT Patch:
 * TPD0: _CRS to XCRS, 205F43525300 -> 205843525300
 * TPD0: _DSM to XTSM, 395F44534D   -> 395854534D
 */
DefinitionBlock ("", "SSDT", 2, "hack", "I2Cpatch", 0x00000000)
{
    External (_SB_.PCI0.HIDD, MethodObj)    // 5 Arguments
    External (_SB_.PCI0.HIDG, FieldUnitObj)
    External (_SB_.PCI0.I2C1.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C1.TPD0.HID2, FieldUnitObj)
    External (_SB_.PCI0.I2C1.TPD0.SBFB, IntObj)
    External (_SB_.PCI0.I2C1.TPD0.XCRS, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.I2C1.TPD0.XTSM, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.TP7D, MethodObj)    // 6 Arguments
    External (_SB_.PCI0.TP7G, FieldUnitObj)

    Scope (_SB.PCI0.I2C1.TPD0)
    {

        If (_OSI ("Darwin"))
        {
            Name (OSYS, 0x07DF)
            Name (SBFX, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0030
                    }
            })
        }
        
        /*
        
        In VoodooI2C 2.7, _DSM is the priority method to obtain GPIO pin
        when _CRS returns invaild values (e.g., only SBFI for Darwin).
        
        However, the default GPIO Pin (0x30) obtained from _DSM for 
        Yoga S740-14IIL does not work, hence extra custom GPIO pin is set
        by a new method SBFX to access GPIO resources and provide a working
        GPIO Pin 0x0E. Then both _CRS and _DSM are modified to return 
        custom GPIO Pin.
        
        Related PR and discussion:
        https://github.com/VoodooI2C/VoodooI2C/pull/468
        
        */
        
        
        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            If (_OSI ("Darwin"))
            {
                If ((Arg0 == HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If ((Arg0 == TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFX))
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }
            Else
            {
                Return (\_SB.PCI0.I2C1.TPD0.XTSM (Arg0, Arg1, Arg2, Arg3))
            }
        }

        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            If (_OSI ("Darwin"))
            {
                Return (ConcatenateResTemplate (SBFB, SBFX))
            }
            Else
            {
                Return (\_SB.PCI0.I2C1.TPD0.XCRS ())
            }
        }
    }
}

