//
// TemplatePreviewRequestDTO.swift
//

//

import Foundation


open class TemplatePreviewRequestDTO: JSONEncodable {

    public var params: Any?
    public var templateId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["params"] = self.params
        nillableDictionary["templateId"] = self.templateId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

