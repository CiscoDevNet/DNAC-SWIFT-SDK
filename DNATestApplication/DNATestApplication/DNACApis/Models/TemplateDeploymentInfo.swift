//
// TemplateDeploymentInfo.swift
//

//

import Foundation


open class TemplateDeploymentInfo: JSONEncodable {

    public var targetInfo: [TemplateDeploymentInfoTargetInfo]?
    public var templateId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["targetInfo"] = self.targetInfo?.encodeToJSON()
        nillableDictionary["templateId"] = self.templateId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

