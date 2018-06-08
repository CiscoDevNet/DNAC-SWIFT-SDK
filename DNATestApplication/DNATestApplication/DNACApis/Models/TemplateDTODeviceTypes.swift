//
// TemplateDTODeviceTypes.swift
//

//

import Foundation


open class TemplateDTODeviceTypes: JSONEncodable {

    public var productFamily: String?
    public var productSeries: String?
    public var productType: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["productFamily"] = self.productFamily
        nillableDictionary["productSeries"] = self.productSeries
        nillableDictionary["productType"] = self.productType

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

