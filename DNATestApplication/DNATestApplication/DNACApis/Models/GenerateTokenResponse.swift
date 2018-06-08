//
// GenerateTokenResponse.swift
//

//

import Foundation


open class GenerateTokenResponse: JSONEncodable {

    public var token: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["Token"] = self.token

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

