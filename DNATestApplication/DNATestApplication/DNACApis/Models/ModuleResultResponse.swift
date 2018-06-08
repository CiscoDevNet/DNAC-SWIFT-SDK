//
// ModuleResultResponse.swift
//

//

import Foundation


open class ModuleResultResponse: JSONEncodable {

    public enum IsFieldReplaceable: String { 
        case unknown = "UNKNOWN"
        case _true = "TRUE"
        case _false = "FALSE"
        case notApplicable = "NOT_APPLICABLE"
    }
    public enum IsReportingAlarmsAllowed: String { 
        case unknown = "UNKNOWN"
        case _true = "TRUE"
        case _false = "FALSE"
        case notApplicable = "NOT_APPLICABLE"
    }
    public var assemblyNumber: String?
    public var assemblyRevision: String?
    public var attributeInfo: Any?
    public var containmentEntity: String?
    public var description: String?
    public var entityPhysicalIndex: String?
    public var id: String?
    public var isFieldReplaceable: IsFieldReplaceable?
    public var isReportingAlarmsAllowed: IsReportingAlarmsAllowed?
    public var manufacturer: String?
    public var moduleIndex: Int32?
    public var name: String?
    public var operationalStateCode: String?
    public var partNumber: String?
    public var serialNumber: String?
    public var vendorEquipmentType: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["assemblyNumber"] = self.assemblyNumber
        nillableDictionary["assemblyRevision"] = self.assemblyRevision
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["containmentEntity"] = self.containmentEntity
        nillableDictionary["description"] = self.description
        nillableDictionary["entityPhysicalIndex"] = self.entityPhysicalIndex
        nillableDictionary["id"] = self.id
        nillableDictionary["isFieldReplaceable"] = self.isFieldReplaceable?.rawValue
        nillableDictionary["isReportingAlarmsAllowed"] = self.isReportingAlarmsAllowed?.rawValue
        nillableDictionary["manufacturer"] = self.manufacturer
        nillableDictionary["moduleIndex"] = self.moduleIndex?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["operationalStateCode"] = self.operationalStateCode
        nillableDictionary["partNumber"] = self.partNumber
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["vendorEquipmentType"] = self.vendorEquipmentType

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

