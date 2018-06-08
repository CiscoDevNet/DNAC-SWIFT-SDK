//
// TemplateDTORange.swift
//

//

import Foundation


open class TemplateDTORange: JSONEncodable {

    public var id: String?
    public var maxValue: Int32?
    public var minValue: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["maxValue"] = self.maxValue?.encodeToJSON()
        nillableDictionary["minValue"] = self.minValue?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

