//
// ClientDetailResponse.swift
//

//

import Foundation


open class ClientDetailResponse: JSONEncodable {

    public var response: ClientDetailResponseResponse?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["response"] = self.response?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

