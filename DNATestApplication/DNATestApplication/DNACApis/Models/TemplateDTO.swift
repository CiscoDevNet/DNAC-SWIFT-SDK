//
// TemplateDTO.swift
//

//

import Foundation


open class TemplateDTO: JSONEncodable {

    public var author: String?
    public var createTime: Int32?
    public var description: String?
    public var deviceTypes: [TemplateDTODeviceTypes]?
    public var id: String?
    public var lastUpdateTime: Int32?
    public var name: String?
    public var parentTemplateId: String?
    public var projectId: String?
    public var projectName: String?
    public var rollbackTemplateContent: String?
    public var rollbackTemplateParams: [TemplateDTORollbackTemplateParams]?
    public var softwareType: String?
    public var softwareVariant: String?
    public var softwareVersion: String?
    public var tags: [String]?
    public var templateContent: String?
    public var templateParams: [TemplateDTORollbackTemplateParams]?
    public var version: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["author"] = self.author
        nillableDictionary["createTime"] = self.createTime?.encodeToJSON()
        nillableDictionary["description"] = self.description
        nillableDictionary["deviceTypes"] = self.deviceTypes?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["lastUpdateTime"] = self.lastUpdateTime?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["parentTemplateId"] = self.parentTemplateId
        nillableDictionary["projectId"] = self.projectId
        nillableDictionary["projectName"] = self.projectName
        nillableDictionary["rollbackTemplateContent"] = self.rollbackTemplateContent
        nillableDictionary["rollbackTemplateParams"] = self.rollbackTemplateParams?.encodeToJSON()
        nillableDictionary["softwareType"] = self.softwareType
        nillableDictionary["softwareVariant"] = self.softwareVariant
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["tags"] = self.tags?.encodeToJSON()
        nillableDictionary["templateContent"] = self.templateContent
        nillableDictionary["templateParams"] = self.templateParams?.encodeToJSON()
        nillableDictionary["version"] = self.version

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

