//
// NetworkDeviceNIOListResultResponse.swift
//

//

import Foundation


open class NetworkDeviceNIOListResultResponse: JSONEncodable {

    public var anchorWlcForAp: String?
    public var authModelId: String?
    public var avgUpdateFrequency: Int32?
    public var bootDateTime: String?
    public var cliStatus: String?
    public var duplicateDeviceId: String?
    public var errorCode: String?
    public var errorDescription: String?
    public var family: String?
    public var hostname: String?
    public var httpStatus: String?
    public var id: String?
    public var imageName: String?
    public var ingressQueueConfig: String?
    public var interfaceCount: String?
    public var inventoryCollectionStatus: String?
    public var inventoryReachabilityStatus: String?
    public var lastUpdated: String?
    public var lineCardCount: String?
    public var lineCardId: String?
    public var location: String?
    public var locationName: String?
    public var macAddress: String?
    public var managementIpAddress: String?
    public var memorySize: String?
    public var netconfStatus: String?
    public var numUpdates: Int32?
    public var pingStatus: String?
    public var platformId: String?
    public var portRange: String?
    public var qosStatus: String?
    public var reachabilityFailureReason: String?
    public var reachabilityStatus: String?
    public var role: String?
    public var roleSource: String?
    public var serialNumber: String?
    public var snmpContact: String?
    public var snmpLocation: String?
    public var snmpStatus: String?
    public var softwareVersion: String?
    public var tag: String?
    public var tagCount: Int32?
    public var type: String?
    public var upTime: String?
    public var vendor: String?
    public var wlcApDeviceStatus: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["anchorWlcForAp"] = self.anchorWlcForAp
        nillableDictionary["authModelId"] = self.authModelId
        nillableDictionary["avgUpdateFrequency"] = self.avgUpdateFrequency?.encodeToJSON()
        nillableDictionary["bootDateTime"] = self.bootDateTime
        nillableDictionary["cliStatus"] = self.cliStatus
        nillableDictionary["duplicateDeviceId"] = self.duplicateDeviceId
        nillableDictionary["errorCode"] = self.errorCode
        nillableDictionary["errorDescription"] = self.errorDescription
        nillableDictionary["family"] = self.family
        nillableDictionary["hostname"] = self.hostname
        nillableDictionary["httpStatus"] = self.httpStatus
        nillableDictionary["id"] = self.id
        nillableDictionary["imageName"] = self.imageName
        nillableDictionary["ingressQueueConfig"] = self.ingressQueueConfig
        nillableDictionary["interfaceCount"] = self.interfaceCount
        nillableDictionary["inventoryCollectionStatus"] = self.inventoryCollectionStatus
        nillableDictionary["inventoryReachabilityStatus"] = self.inventoryReachabilityStatus
        nillableDictionary["lastUpdated"] = self.lastUpdated
        nillableDictionary["lineCardCount"] = self.lineCardCount
        nillableDictionary["lineCardId"] = self.lineCardId
        nillableDictionary["location"] = self.location
        nillableDictionary["locationName"] = self.locationName
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["managementIpAddress"] = self.managementIpAddress
        nillableDictionary["memorySize"] = self.memorySize
        nillableDictionary["netconfStatus"] = self.netconfStatus
        nillableDictionary["numUpdates"] = self.numUpdates?.encodeToJSON()
        nillableDictionary["pingStatus"] = self.pingStatus
        nillableDictionary["platformId"] = self.platformId
        nillableDictionary["portRange"] = self.portRange
        nillableDictionary["qosStatus"] = self.qosStatus
        nillableDictionary["reachabilityFailureReason"] = self.reachabilityFailureReason
        nillableDictionary["reachabilityStatus"] = self.reachabilityStatus
        nillableDictionary["role"] = self.role
        nillableDictionary["roleSource"] = self.roleSource
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["snmpContact"] = self.snmpContact
        nillableDictionary["snmpLocation"] = self.snmpLocation
        nillableDictionary["snmpStatus"] = self.snmpStatus
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["tag"] = self.tag
        nillableDictionary["tagCount"] = self.tagCount?.encodeToJSON()
        nillableDictionary["type"] = self.type
        nillableDictionary["upTime"] = self.upTime
        nillableDictionary["vendor"] = self.vendor
        nillableDictionary["wlcApDeviceStatus"] = self.wlcApDeviceStatus

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

