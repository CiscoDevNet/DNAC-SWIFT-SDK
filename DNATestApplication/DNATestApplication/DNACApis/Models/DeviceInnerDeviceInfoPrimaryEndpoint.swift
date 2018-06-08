//
// DeviceInnerDeviceInfoPrimaryEndpoint.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoPrimaryEndpoint: JSONEncodable {

    public var certificate: String?
    public var fqdn: String?
    public var ipv4Address: Any?
    public var ipv6Address: Any?
    public var port: Int32?
    public var _protocol: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["certificate"] = self.certificate
        nillableDictionary["fqdn"] = self.fqdn
        nillableDictionary["ipv4Address"] = self.ipv4Address
        nillableDictionary["ipv6Address"] = self.ipv6Address
        nillableDictionary["port"] = self.port?.encodeToJSON()
        nillableDictionary["protocol"] = self._protocol

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

