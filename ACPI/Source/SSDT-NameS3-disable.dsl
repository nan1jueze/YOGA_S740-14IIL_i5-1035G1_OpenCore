/*
* Patch for AOAC, disable dummy _S3 method
* Name (_S3, ......
* URL: https://github.com/daliansky/OC-little
*
* In config ACPI, _S3 to XS3
* Find:     5F53335F
* Replace:  5853335F
*/


DefinitionBlock ("", "SSDT", 2, "ACDT", "S3-Fix", 0x00000000)
{
    External (XS3_, IntObj)

    If (_OSI ("Darwin")){}
    Else
    {
        Method (_S3, 0, NotSerialized)  // _S3_: S3 System State
        {
            Return (XS3) /* External reference */
        }
    }
}

