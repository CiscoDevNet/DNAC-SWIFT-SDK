//
// WirelessInfoResultResponse.swift
//

//

import Foundation


open class WirelessInfoResultResponse: JSONEncodable {

    public enum WirelessLicenseInfo: String { 
        case advantage = "ADVANTAGE"
        case essentials = "ESSENTIALS"
    }
    public var adminEnabledPorts: [Int32]?
    public var apGroupName: String?
    public var deviceId: String?
    public var ethMacAddress: String?
    public var flexGroupName: String?
    public var id: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var lagModeEnabled: Bool?
    public var netconfEnabled: Bool?
    public var wirelessLicenseInfo: WirelessLicenseInfo?
    public var wirelessPackageInstalled: Bool?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["adminEnabledPorts"] = self.adminEnabledPorts?.encodeToJSON()
        nillableDictionary["apGroupName"] = self.apGroupName
        nillableDictionary["deviceId"] = self.deviceId
        nillableDictionary["ethMacAddress"] = self.ethMacAddress
        nillableDictionary["flexGroupName"] = self.flexGroupName
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["lagModeEnabled"] = self.lagModeEnabled
        nillableDictionary["netconfEnabled"] = self.netconfEnabled
        nillableDictionary["wirelessLicenseInfo"] = self.wirelessLicenseInfo?.rawValue
        nillableDictionary["wirelessPackageInstalled"] = self.wirelessPackageInstalled

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

