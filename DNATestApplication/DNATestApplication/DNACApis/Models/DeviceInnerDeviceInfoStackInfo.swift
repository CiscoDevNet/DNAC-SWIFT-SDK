//
// DeviceInnerDeviceInfoStackInfo.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoStackInfo: JSONEncodable {

    public var isFullRing: Bool?
    public var stackMemberList: [DeviceInnerDeviceInfoStackInfoStackMemberList]?
    public var stackRingProtocol: String?
    public var supportsStackWorkflows: Bool?
    public var totalMemberCount: Int32?
    public var validLicenseLevels: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["isFullRing"] = self.isFullRing
        nillableDictionary["stackMemberList"] = self.stackMemberList?.encodeToJSON()
        nillableDictionary["stackRingProtocol"] = self.stackRingProtocol
        nillableDictionary["supportsStackWorkflows"] = self.supportsStackWorkflows
        nillableDictionary["totalMemberCount"] = self.totalMemberCount?.encodeToJSON()
        nillableDictionary["validLicenseLevels"] = self.validLicenseLevels?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

