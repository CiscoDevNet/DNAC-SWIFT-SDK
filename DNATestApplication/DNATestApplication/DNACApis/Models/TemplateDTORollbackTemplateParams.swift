//
// TemplateDTORollbackTemplateParams.swift
//

//

import Foundation


open class TemplateDTORollbackTemplateParams: JSONEncodable {

    public enum DataType: String { 
        case string = "STRING"
        case integer = "INTEGER"
        case ipaddress = "IPADDRESS"
        case macaddress = "MACADDRESS"
        case sectiondivider = "SECTIONDIVIDER"
    }
    public var dataType: DataType?
    public var defaultValue: String?
    public var description: String?
    public var displayName: String?
    public var group: String?
    public var id: String?
    public var instructionText: String?
    public var key: String?
    public var order: Int32?
    public var parameterName: String?
    public var provider: String?
    public var range: [TemplateDTORange]?
    public var _required: Bool?
    public var selection: Any?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["dataType"] = self.dataType?.rawValue
        nillableDictionary["defaultValue"] = self.defaultValue
        nillableDictionary["description"] = self.description
        nillableDictionary["displayName"] = self.displayName
        nillableDictionary["group"] = self.group
        nillableDictionary["id"] = self.id
        nillableDictionary["instructionText"] = self.instructionText
        nillableDictionary["key"] = self.key
        nillableDictionary["order"] = self.order?.encodeToJSON()
        nillableDictionary["parameterName"] = self.parameterName
        nillableDictionary["provider"] = self.provider
        nillableDictionary["range"] = self.range?.encodeToJSON()
        nillableDictionary["required"] = self._required
        nillableDictionary["selection"] = self.selection

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

