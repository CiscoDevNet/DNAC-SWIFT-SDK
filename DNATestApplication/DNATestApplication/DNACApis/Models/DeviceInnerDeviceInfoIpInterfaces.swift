//
// DeviceInnerDeviceInfoIpInterfaces.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoIpInterfaces: JSONEncodable {

    public var ipv4Address: Any?
    public var ipv6AddressList: [Any]?
    public var macAddress: String?
    public var name: String?
    public var status: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["ipv4Address"] = self.ipv4Address
        nillableDictionary["ipv6AddressList"] = self.ipv6AddressList?.encodeToJSON()
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["name"] = self.name
        nillableDictionary["status"] = self.status

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

