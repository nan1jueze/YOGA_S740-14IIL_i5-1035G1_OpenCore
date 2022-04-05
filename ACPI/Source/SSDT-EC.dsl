/*
 * AppleUsbPower compatibility table for legacy hardware.
 *
 * Be warned that power supply values can be different
 * for different systems. Depending on the configuration
 * the values must be present in injected IOKitPersonalities
 * for com.apple.driver.AppleUSBMergeNub. iPad remains being
 * the most reliable device for testing USB port charging.
 *
 * Try NOT to rename EC0, H_EC, etc. to EC.
 * These devices are incompatible with macOS and may break
 * at any time. AppleACPIEC kext must NOT load on desktops.
 * See the disable code below.
 *
 * While on some laptops, this kext is essential to access EC
 * region for battery status etc. Please ignore EC related
 * patches under the circumstance.
 *
 * Reference USB: https://applelife.ru/posts/550233
 * Reference EC: https://applelife.ru/posts/807985
 * Credit to Acidantera, modified from _STA to _OSI implementation
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "SsdtEC", 0x00001000)
{

    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_.ECAV, IntObj)

    If (_OSI ("Darwin"))
    {
        Scope (\_SB.PCI0.LPCB)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                
                // Initialize ECAV (EC Availiablity) before macOS evaluating EC0 device
                // macOS initialize devices with _STA, while Windows start with _REG and _INI
                // However, _STA of EC0 still relys on functions in _REG, which leads to uninitialized 
                // parameters in _STA.
                //
                // This helps to fix some EC-related issue without modifying ECDT table.
                
                \_SB.PCI0.LPCB.EC0.ECAV = One
                Return (0x0F)
            }

            Device (EC)
            {
                Name (_HID, "ACID0001")  // _HID: Hardware ID
            }
        }
    }
}

