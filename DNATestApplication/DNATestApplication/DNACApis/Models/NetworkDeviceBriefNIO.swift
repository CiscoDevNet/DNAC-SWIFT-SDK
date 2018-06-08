//
// NetworkDeviceBriefNIO.swift
//

//

import Foundation


open class NetworkDeviceBriefNIO: JSONEncodable {

    public var id: String?
    public var role: String?
    public var roleSource: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["role"] = self.role
        nillableDictionary["roleSource"] = self.roleSource

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

