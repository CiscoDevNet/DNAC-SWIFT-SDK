//
// SettingsDefaultProfile.swift
//

//

import Foundation


open class SettingsDefaultProfile: JSONEncodable {

    public var cert: String?
    public var fqdnAddresses: [String]?
    public var ipAddresses: [String]?
    public var port: Int32?
    public var proxy: Bool?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cert"] = self.cert
        nillableDictionary["fqdnAddresses"] = self.fqdnAddresses?.encodeToJSON()
        nillableDictionary["ipAddresses"] = self.ipAddresses?.encodeToJSON()
        nillableDictionary["port"] = self.port?.encodeToJSON()
        nillableDictionary["proxy"] = self.proxy

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

