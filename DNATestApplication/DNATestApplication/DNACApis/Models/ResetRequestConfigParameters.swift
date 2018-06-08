//
// ResetRequestConfigParameters.swift
//

//

import Foundation


open class ResetRequestConfigParameters: JSONEncodable {

    public var key: String?
    public var value: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["key"] = self.key
        nillableDictionary["value"] = self.value

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

