//
// ClientHealthResponseScoreCategory.swift
//

//

import Foundation


open class ClientHealthResponseScoreCategory: JSONEncodable {

    public var scoreCategory: String?
    public var value: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["scoreCategory"] = self.scoreCategory
        nillableDictionary["value"] = self.value

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

