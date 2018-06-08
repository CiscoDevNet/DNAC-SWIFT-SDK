//
// FunctionalCapabilityListResultFunctionDetails.swift
//

//

import Foundation


open class FunctionalCapabilityListResultFunctionDetails: JSONEncodable {

    public var attributeInfo: Any?
    public var id: String?
    public var propertyName: String?
    public var stringValue: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["id"] = self.id
        nillableDictionary["propertyName"] = self.propertyName
        nillableDictionary["stringValue"] = self.stringValue

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

