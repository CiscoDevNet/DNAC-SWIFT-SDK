//
// ClientDetailResponseResponseTopologyLinks.swift
//

//

import Foundation


open class ClientDetailResponseResponseTopologyLinks: JSONEncodable {

    public var source: String?
    public var linkStatus: String?
    public var label: [String]?
    public var target: String?
    public var id: String?
    public var portUtilization: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["source"] = self.source
        nillableDictionary["linkStatus"] = self.linkStatus
        nillableDictionary["label"] = self.label?.encodeToJSON()
        nillableDictionary["target"] = self.target
        nillableDictionary["id"] = self.id
        nillableDictionary["portUtilization"] = self.portUtilization

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

