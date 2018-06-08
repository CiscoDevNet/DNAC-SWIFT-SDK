//
// NetworkDeviceListResultResponse.swift
//

//

import Foundation


open class NetworkDeviceListResultResponse: JSONEncodable {

    public var apManagerInterfaceIp: String?
    public var associatedWlcIp: String?
    public var bootDateTime: String?
    public var collectionInterval: String?
    public var collectionStatus: String?
    public var errorCode: String?
    public var errorDescription: String?
    public var family: String?
    public var hostname: String?
    public var id: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var interfaceCount: String?
    public var inventoryStatusDetail: String?
    public var lastUpdateTime: String?
    public var lastUpdated: String?
    public var lineCardCount: String?
    public var lineCardId: String?
    public var location: String?
    public var locationName: String?
    public var macAddress: String?
    public var managementIpAddress: String?
    public var memorySize: String?
    public var platformId: String?
    public var reachabilityFailureReason: String?
    public var reachabilityStatus: String?
    public var role: String?
    public var roleSource: String?
    public var serialNumber: String?
    public var series: String?
    public var snmpContact: String?
    public var snmpLocation: String?
    public var softwareType: String?
    public var softwareVersion: String?
    public var tagCount: String?
    public var tunnelUdpPort: String?
    public var type: String?
    public var upTime: String?
    public var waasDeviceMode: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["apManagerInterfaceIp"] = self.apManagerInterfaceIp
        nillableDictionary["associatedWlcIp"] = self.associatedWlcIp
        nillableDictionary["bootDateTime"] = self.bootDateTime
        nillableDictionary["collectionInterval"] = self.collectionInterval
        nillableDictionary["collectionStatus"] = self.collectionStatus
        nillableDictionary["errorCode"] = self.errorCode
        nillableDictionary["errorDescription"] = self.errorDescription
        nillableDictionary["family"] = self.family
        nillableDictionary["hostname"] = self.hostname
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["interfaceCount"] = self.interfaceCount
        nillableDictionary["inventoryStatusDetail"] = self.inventoryStatusDetail
        nillableDictionary["lastUpdateTime"] = self.lastUpdateTime
        nillableDictionary["lastUpdated"] = self.lastUpdated
        nillableDictionary["lineCardCount"] = self.lineCardCount
        nillableDictionary["lineCardId"] = self.lineCardId
        nillableDictionary["location"] = self.location
        nillableDictionary["locationName"] = self.locationName
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["managementIpAddress"] = self.managementIpAddress
        nillableDictionary["memorySize"] = self.memorySize
        nillableDictionary["platformId"] = self.platformId
        nillableDictionary["reachabilityFailureReason"] = self.reachabilityFailureReason
        nillableDictionary["reachabilityStatus"] = self.reachabilityStatus
        nillableDictionary["role"] = self.role
        nillableDictionary["roleSource"] = self.roleSource
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["series"] = self.series
        nillableDictionary["snmpContact"] = self.snmpContact
        nillableDictionary["snmpLocation"] = self.snmpLocation
        nillableDictionary["softwareType"] = self.softwareType
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["tagCount"] = self.tagCount
        nillableDictionary["tunnelUdpPort"] = self.tunnelUdpPort
        nillableDictionary["type"] = self.type
        nillableDictionary["upTime"] = self.upTime
        nillableDictionary["waasDeviceMode"] = self.waasDeviceMode

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

