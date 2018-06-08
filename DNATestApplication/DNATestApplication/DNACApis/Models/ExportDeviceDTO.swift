//
// ExportDeviceDTO.swift
//

//

import Foundation


open class ExportDeviceDTO: JSONEncodable {

    public enum OperationEnum: String { 
        case credentialdetails = "CREDENTIALDETAILS"
        case devicedetails = "DEVICEDETAILS"
    }
    public var deviceUuids: [String]?
    public var id: String?
    public var operationEnum: OperationEnum?
    public var parameters: [String]?
    public var password: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceUuids"] = self.deviceUuids?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["operationEnum"] = self.operationEnum?.rawValue
        nillableDictionary["parameters"] = self.parameters?.encodeToJSON()
        nillableDictionary["password"] = self.password

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

