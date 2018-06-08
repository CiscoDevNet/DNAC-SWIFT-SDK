//
// ResetRequestDeviceResetList.swift
//

//

import Foundation


open class ResetRequestDeviceResetList: JSONEncodable {

    public var configList: [ResetRequestConfigList]?
    public var deviceId: String?
    public var licenseLevel: String?
    public var licenseType: String?
    public var topOfStackSerialNumber: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["configList"] = self.configList?.encodeToJSON()
        nillableDictionary["deviceId"] = self.deviceId
        nillableDictionary["licenseLevel"] = self.licenseLevel
        nillableDictionary["licenseType"] = self.licenseType
        nillableDictionary["topOfStackSerialNumber"] = self.topOfStackSerialNumber

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

