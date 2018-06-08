//
// ClientHealthResponseResponse.swift
//

//

import Foundation


open class ClientHealthResponseResponse: JSONEncodable {

    public var siteId: String?
    public var scoreDetail: [ClientHealthResponseScoreDetail]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["siteId"] = self.siteId
        nillableDictionary["scoreDetail"] = self.scoreDetail?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

