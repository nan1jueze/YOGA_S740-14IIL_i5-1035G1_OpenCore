/*
 * Fixed ECDT table, provide initialization on EC fields before
 * Namespace of EC0 is initialized.
 * DO NOT MAKE CHANGES ON GPE NUMBER
 *
 * Drop origion ECDT:
 * ACPI->Delete
 * OEMTableID: 43422D3031202020
 * Table Signature: 45434454
 */

[000h 0000   4]                    Signature : "ECDT"    [Embedded Controller Boot Resources Table]
[004h 0004   4]                 Table Length : 00000054
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : 97
[00Ah 0010   6]                       Oem ID : "LENOVO"
[010h 0016   8]                 Oem Table ID : "CB-01   "
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "INTL"
[020h 0032   4]        Asl Compiler Revision : 20200925


[024h 0036  12]      Command/Status Register : [Generic Address Structure]
[024h 0036   1]                     Space ID : 01 [SystemIO]
[025h 0037   1]                    Bit Width : 08
[026h 0038   1]                   Bit Offset : 00
[027h 0039   1]         Encoded Access Width : 00 [Undefined/Legacy]
[028h 0040   8]                      Address : 0000000000000066

[030h 0048  12]                Data Register : [Generic Address Structure]
[030h 0048   1]                     Space ID : 01 [SystemIO]
[031h 0049   1]                    Bit Width : 08
[032h 0050   1]                   Bit Offset : 00
[033h 0051   1]         Encoded Access Width : 00 [Undefined/Legacy]
[034h 0052   8]                      Address : 0000000000000062

[03Ch 0060   4]                          UID : 00000001
[040h 0064   1]                   GPE Number : 6E
[041h 0065  19]                     Namepath : "\_SB.PCI0.LPCB.EC0"

Raw Table Data: Length 84 (0x54)

    0000: 45 43 44 54 54 00 00 00 01 97 4C 45 4E 4F 56 4F  // ECDTT.....LENOVO
    0010: 43 42 2D 30 31 20 20 20 01 00 00 00 49 4E 54 4C  // CB-01   ....INTL
    0020: 25 09 20 20 01 08 00 00 66 00 00 00 00 00 00 00  // %.  ....f.......
    0030: 01 08 00 00 62 00 00 00 00 00 00 00 01 00 00 00  // ....b...........
    0040: 6E 5C 5F 53 42 2E 50 43 49 30 2E 4C 50 43 42 2E  // n\_SB.PCI0.LPCB.
    0050: 45 43 30 00                                      // EC0.
