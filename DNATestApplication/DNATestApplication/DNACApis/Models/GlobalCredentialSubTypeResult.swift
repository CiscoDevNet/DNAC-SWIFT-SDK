//
// GlobalCredentialSubTypeResult.swift
//

//

import Foundation


open class GlobalCredentialSubTypeResult: JSONEncodable {

    public var response: String?
    public var version: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["response"] = self.response
        nillableDictionary["version"] = self.version

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

