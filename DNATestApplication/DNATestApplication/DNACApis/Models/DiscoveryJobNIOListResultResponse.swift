//
// DiscoveryJobNIOListResultResponse.swift
//

//

import Foundation


open class DiscoveryJobNIOListResultResponse: JSONEncodable {

    public var attributeInfo: Any?
    public var cliStatus: String?
    public var discoveryStatus: String?
    public var endTime: String?
    public var httpStatus: String?
    public var id: String?
    public var inventoryCollectionStatus: String?
    public var inventoryReachabilityStatus: String?
    public var ipAddress: String?
    public var jobStatus: String?
    public var name: String?
    public var netconfStatus: String?
    public var pingStatus: String?
    public var snmpStatus: String?
    public var startTime: String?
    public var taskId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["cliStatus"] = self.cliStatus
        nillableDictionary["discoveryStatus"] = self.discoveryStatus
        nillableDictionary["endTime"] = self.endTime
        nillableDictionary["httpStatus"] = self.httpStatus
        nillableDictionary["id"] = self.id
        nillableDictionary["inventoryCollectionStatus"] = self.inventoryCollectionStatus
        nillableDictionary["inventoryReachabilityStatus"] = self.inventoryReachabilityStatus
        nillableDictionary["ipAddress"] = self.ipAddress
        nillableDictionary["jobStatus"] = self.jobStatus
        nillableDictionary["name"] = self.name
        nillableDictionary["netconfStatus"] = self.netconfStatus
        nillableDictionary["pingStatus"] = self.pingStatus
        nillableDictionary["snmpStatus"] = self.snmpStatus
        nillableDictionary["startTime"] = self.startTime
        nillableDictionary["taskId"] = self.taskId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

