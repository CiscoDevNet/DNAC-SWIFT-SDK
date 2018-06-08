//
// SiteResultResponse.swift
//

//

import Foundation


open class SiteResultResponse: JSONEncodable {

    public var sites: [SiteResultResponseSites]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["sites"] = self.sites?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

