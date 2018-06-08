//
// Settings.swift
//

//

import Foundation


open class Settings: JSONEncodable {

    public var id: String?
    public var aaaCredentials: DeviceInnerDeviceInfoAaaCredentials?
    public var acceptEula: Bool?
    public var defaultProfile: SettingsDefaultProfile?
    public var savaMappingList: [SettingsSavaMappingList]?
    public var taskTimeOuts: SettingsTaskTimeOuts?
    public var tenantId: String?
    public var version: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["_id"] = self.id
        nillableDictionary["aaaCredentials"] = self.aaaCredentials?.encodeToJSON()
        nillableDictionary["acceptEula"] = self.acceptEula
        nillableDictionary["defaultProfile"] = self.defaultProfile?.encodeToJSON()
        nillableDictionary["savaMappingList"] = self.savaMappingList?.encodeToJSON()
        nillableDictionary["taskTimeOuts"] = self.taskTimeOuts?.encodeToJSON()
        nillableDictionary["tenantId"] = self.tenantId
        nillableDictionary["version"] = self.version?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

