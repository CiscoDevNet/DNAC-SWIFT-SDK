//
// FunctionalCapabilityListResultResponse.swift
//

//

import Foundation


open class FunctionalCapabilityListResultResponse: JSONEncodable {

    public var attributeInfo: Any?
    public var deviceId: String?
    public var functionalCapability: [FunctionalCapabilityListResultFunctionalCapability]?
    public var id: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["deviceId"] = self.deviceId
        nillableDictionary["functionalCapability"] = self.functionalCapability?.encodeToJSON()
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

