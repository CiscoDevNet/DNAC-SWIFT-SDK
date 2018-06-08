//
// ClientHealthResponse.swift
//

//

import Foundation


open class ClientHealthResponse: JSONEncodable {

    public var response: [ClientHealthResponseResponse]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["response"] = self.response?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

