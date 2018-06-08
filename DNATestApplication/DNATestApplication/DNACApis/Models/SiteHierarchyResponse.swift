//
// SiteHierarchyResponse.swift
//

//

import Foundation


open class SiteHierarchyResponse: JSONEncodable {

    public var response: [SiteHierarchyResponseResponse]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["response"] = self.response?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

