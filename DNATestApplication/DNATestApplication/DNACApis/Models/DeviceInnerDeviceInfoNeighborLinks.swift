//
// DeviceInnerDeviceInfoNeighborLinks.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoNeighborLinks: JSONEncodable {

    public var localInterfaceName: String?
    public var localMacAddress: String?
    public var localShortInterfaceName: String?
    public var remoteDeviceName: String?
    public var remoteInterfaceName: String?
    public var remoteMacAddress: String?
    public var remotePlatform: String?
    public var remoteShortInterfaceName: String?
    public var remoteVersion: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["localInterfaceName"] = self.localInterfaceName
        nillableDictionary["localMacAddress"] = self.localMacAddress
        nillableDictionary["localShortInterfaceName"] = self.localShortInterfaceName
        nillableDictionary["remoteDeviceName"] = self.remoteDeviceName
        nillableDictionary["remoteInterfaceName"] = self.remoteInterfaceName
        nillableDictionary["remoteMacAddress"] = self.remoteMacAddress
        nillableDictionary["remotePlatform"] = self.remotePlatform
        nillableDictionary["remoteShortInterfaceName"] = self.remoteShortInterfaceName
        nillableDictionary["remoteVersion"] = self.remoteVersion

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

