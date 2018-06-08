//
// VlanListResultResponse.swift
//

//

import Foundation


open class VlanListResultResponse: JSONEncodable {

    public var interfaceName: String?
    public var ipAddress: String?
    public var mask: Int32?
    public var networkAddress: String?
    public var numberOfIPs: Int32?
    public var _prefix: String?
    public var vlanNumber: Int32?
    public var vlanType: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["interfaceName"] = self.interfaceName
        nillableDictionary["ipAddress"] = self.ipAddress
        nillableDictionary["mask"] = self.mask?.encodeToJSON()
        nillableDictionary["networkAddress"] = self.networkAddress
        nillableDictionary["numberOfIPs"] = self.numberOfIPs?.encodeToJSON()
        nillableDictionary["prefix"] = self._prefix
        nillableDictionary["vlanNumber"] = self.vlanNumber?.encodeToJSON()
        nillableDictionary["vlanType"] = self.vlanType

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

