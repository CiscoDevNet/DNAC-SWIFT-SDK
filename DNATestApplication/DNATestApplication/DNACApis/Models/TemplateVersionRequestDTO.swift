//
// TemplateVersionRequestDTO.swift
//

//

import Foundation


open class TemplateVersionRequestDTO: JSONEncodable {

    public var comments: String?
    public var templateId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comments"] = self.comments
        nillableDictionary["templateId"] = self.templateId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

