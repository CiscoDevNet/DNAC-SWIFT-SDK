//
// SAVAMappingProfile.swift
//

//

import Foundation


open class SAVAMappingProfile: JSONEncodable {

    public var addressFqdn: String?
    public var addressIpV4: String?
    public var cert: String?
    public var makeDefault: Bool?
    public var name: String?
    public var port: Int32?
    public var profileId: String?
    public var proxy: Bool?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["addressFqdn"] = self.addressFqdn
        nillableDictionary["addressIpV4"] = self.addressIpV4
        nillableDictionary["cert"] = self.cert
        nillableDictionary["makeDefault"] = self.makeDefault
        nillableDictionary["name"] = self.name
        nillableDictionary["port"] = self.port?.encodeToJSON()
        nillableDictionary["profileId"] = self.profileId
        nillableDictionary["proxy"] = self.proxy

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

