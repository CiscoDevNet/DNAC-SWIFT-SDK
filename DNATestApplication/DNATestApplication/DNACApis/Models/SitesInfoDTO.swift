//
// SitesInfoDTO.swift
//

//

import Foundation


open class SitesInfoDTO: JSONEncodable {

    public var siteUuids: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["siteUuids"] = self.siteUuids?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

