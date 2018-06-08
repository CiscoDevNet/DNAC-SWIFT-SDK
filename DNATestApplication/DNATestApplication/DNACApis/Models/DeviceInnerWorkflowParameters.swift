//
// DeviceInnerWorkflowParameters.swift
//

//

import Foundation


open class DeviceInnerWorkflowParameters: JSONEncodable {

    public var configList: [ResetRequestConfigList]?
    public var licenseLevel: String?
    public var licenseType: String?
    public var topOfStackSerialNumber: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["configList"] = self.configList?.encodeToJSON()
        nillableDictionary["licenseLevel"] = self.licenseLevel
        nillableDictionary["licenseType"] = self.licenseType
        nillableDictionary["topOfStackSerialNumber"] = self.topOfStackSerialNumber

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

