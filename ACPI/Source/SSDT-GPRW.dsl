/*
* 0D6D patch, credit to OC-little
* URL: https://github.com/daliansky/OC-little
*
* In config ACPI, GPRW to XPRW
* Find:     47505257 02
* Replace:  58505257 02
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "GPRW", 0x00000000)
{
    External (XPRW, MethodObj)    // 2 Arguments

    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            If ((0x6D == Arg0))
            {
                Return (Package (0x02)
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))
            {
                Return (Package (0x02)
                {
                    0x0D, 
                    Zero
                })
            }
        }

        Return (XPRW (Arg0, Arg1))
    }
}

