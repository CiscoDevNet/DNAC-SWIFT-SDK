//
// ClientDetailResponseResponseDetailHealthScore.swift
//

//

import Foundation


open class ClientDetailResponseResponseDetailHealthScore: JSONEncodable {

    public var healthType: String?
    public var reason: String?
    public var score: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["healthType"] = self.healthType
        nillableDictionary["reason"] = self.reason
        nillableDictionary["score"] = self.score

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

