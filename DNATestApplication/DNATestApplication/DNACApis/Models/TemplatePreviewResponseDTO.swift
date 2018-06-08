//
// TemplatePreviewResponseDTO.swift
//

//

import Foundation


open class TemplatePreviewResponseDTO: JSONEncodable {

    public var cliPreview: String?
    public var templateId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cliPreview"] = self.cliPreview
        nillableDictionary["templateId"] = self.templateId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

