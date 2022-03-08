/*
 * All-in-one Property/Fake device injection
 */

DefinitionBlock ("", "SSDT", 2, "FAKE", "PROP", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX._OFF, MethodObj)    
    External (_SB_.PCI0.SBUS, DeviceObj)
    External (_SB_.PR00, ProcessorObj)
    External (STAS, FieldUnitObj)
    
    
    //Start for macOS 
    If (_OSI ("Darwin"))
    {
        //Enable RTC, disable AWAC
        //Credit to OC-little
        
        STAS = One    
                              
        
        //Disable DGPU, for AOAC devices
        //Credit to OC-little
        
        Device (DGPU)               
        {
            Name (_HID, "DGPU1000")  // _HID: Hardware ID
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                If (CondRefOf (\_SB.PCI0.RP05.PXSX._OFF))
                {
                    \_SB.PCI0.RP05.PXSX._OFF ()
                }
            }
        }
        
        
        //Plugin-type = 1
        //Credit to OC-little, Acidanthera

        Method (PMPM, 4, NotSerialized)
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x02)
            {
                "plugin-type", 
                One
            })
        }



        Scope (_SB)
        {
            
            //USB current fix
            //Credit to OC-little, Acidanthera
            
            Device (USBX)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x08)
                    {
                        "kUSBSleepPowerSupply", 
                        0x13EC, 
                        "kUSBSleepPortCurrentLimit", 
                        0x0834, 
                        "kUSBWakePowerSupply", 
                        0x13EC, 
                        "kUSBWakePortCurrentLimit", 
                        0x0834
                    })
                }
            }
            
            

            //Fake light sensor to store backlight level
            //Credit to OC-little, Acidanthera
            
            Device (ALS0)
            {
                Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
                Name (_CID, "smc-als")  // _CID: Compatible ID
                Name (_ALI, 0x012C)  // _ALI: Ambient Light Illuminance
                Name (_ALR, Package (0x01)  // _ALR: Ambient Light Response
                {
                    Package (0x02)
                    {
                        0x64, 
                        0x012C
                    }
                })
            }


            // Enable backlight control
            // Credit to OC-little, Acidanthera
            // PNLF renamed XNLF
            // 504E4C46 -> 584E4C46
            
            Device (PNLF)
            {
                Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
                Name (_CID, "backlight")  // _CID: Compatible ID
                Name (_UID, 0x13)  // _UID: Unique ID
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0B)
                }
            }

            
            // Add sleep button, for AOAC device
            // Credit to OC-little
            
            Device (SLPB)
            {
                Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0B)
                }
            }

            // Enable DeepIdle for AOAC device
            // Credit to OC-little, Piker.Alpha
            // Source:
            // https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/
            
            Method (LPS0, 0, NotSerialized)
            {
                Return (One)
            }
        }


        // Enable SMBus
        // Credit to OC-little, Acidanthera
        Scope (_SB.PCI0)
        {
            Device (MCHC)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }
        }

        Device (_SB.PCI0.SBUS.BUS0)
        {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address
            Device (DVL0)
            {
                Name (_ADR, 0x57)  // _ADR: Address
                Name (_CID, "diagsvault")  // _CID: Compatible ID
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If (!Arg2)
                    {
                        Return (Buffer (One)
                        {
                             0x57                                             // W
                        })
                    }

                    Return (Package (0x02)
                    {
                        "address", 
                        0x57
                    })
                }
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }
        
        
        

        Scope (_SB.PCI0.LPCB)
        {
            // Force Initialization for LPCB devices
            // Local0 under _SB.PCI0.LPCB.EC0 is not initialized,
            // which causes BAT0 returns 0x0 and brake some Fn keys
            // Create a local OSYS variable to force initialize the
            // value while no extra OS variable are applied to ACPI.
            
            Name (OSYS, 0x07DF)
            
            
            
            //Enable NVRAM
            //Credit to OC-little
            
            Device (PMCR)
            {
                Name (_HID, EisaId ("APP9876"))  // _HID: Hardware ID
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0B)
                }

                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Memory32Fixed (ReadWrite,
                        0xFE000000,         // Address Base
                        0x00010000,         // Address Length
                        )
                })
            }
        }



        // Enable DeepIdle for AOAC device
        // Credit to OC-little, Piker.Alpha
        // Source:
        // https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/
        
        Scope (_GPE)
        {
            Method (LXEN, 0, NotSerialized)
            {
                Return (One)
            }
        }
 


        //Plugin-type = 1
        //Credit to OC-little, Acidanthera
        
        Scope (_SB.PR00)
        {
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Return (PMPM (Arg0, Arg1, Arg2, Arg3))
            }
        }
    }
}

