//
// DeleteSSIDResponse.swift
//

//

import Foundation


open class DeleteSSIDResponse: JSONEncodable {

    public var isError: Bool?
    public var failureReason: String?
    public var successMessage: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["isError"] = self.isError
        nillableDictionary["failureReason"] = self.failureReason
        nillableDictionary["successMessage"] = self.successMessage

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

