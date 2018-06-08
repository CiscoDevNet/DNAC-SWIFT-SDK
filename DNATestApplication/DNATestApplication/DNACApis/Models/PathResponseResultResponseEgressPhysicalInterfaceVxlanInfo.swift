//
// PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo: JSONEncodable {

    public var dscp: String?
    public var vnid: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["dscp"] = self.dscp
        nillableDictionary["vnid"] = self.vnid

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

