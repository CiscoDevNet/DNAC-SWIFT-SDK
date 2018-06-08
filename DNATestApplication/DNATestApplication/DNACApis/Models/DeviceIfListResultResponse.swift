//
// DeviceIfListResultResponse.swift
//

//

import Foundation


open class DeviceIfListResultResponse: JSONEncodable {

    public var adminStatus: String?
    public var className: String?
    public var description: String?
    public var deviceId: String?
    public var duplex: String?
    public var id: String?
    public var ifIndex: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var interfaceType: String?
    public var ipv4Address: String?
    public var ipv4Mask: String?
    public var isisSupport: String?
    public var lastUpdated: String?
    public var macAddress: String?
    public var mappedPhysicalInterfaceId: String?
    public var mappedPhysicalInterfaceName: String?
    public var mediaType: String?
    public var nativeVlanId: String?
    public var ospfSupport: String?
    public var pid: String?
    public var portMode: String?
    public var portName: String?
    public var portType: String?
    public var serialNo: String?
    public var series: String?
    public var speed: String?
    public var status: String?
    public var vlanId: String?
    public var voiceVlan: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["adminStatus"] = self.adminStatus
        nillableDictionary["className"] = self.className
        nillableDictionary["description"] = self.description
        nillableDictionary["deviceId"] = self.deviceId
        nillableDictionary["duplex"] = self.duplex
        nillableDictionary["id"] = self.id
        nillableDictionary["ifIndex"] = self.ifIndex
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["interfaceType"] = self.interfaceType
        nillableDictionary["ipv4Address"] = self.ipv4Address
        nillableDictionary["ipv4Mask"] = self.ipv4Mask
        nillableDictionary["isisSupport"] = self.isisSupport
        nillableDictionary["lastUpdated"] = self.lastUpdated
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["mappedPhysicalInterfaceId"] = self.mappedPhysicalInterfaceId
        nillableDictionary["mappedPhysicalInterfaceName"] = self.mappedPhysicalInterfaceName
        nillableDictionary["mediaType"] = self.mediaType
        nillableDictionary["nativeVlanId"] = self.nativeVlanId
        nillableDictionary["ospfSupport"] = self.ospfSupport
        nillableDictionary["pid"] = self.pid
        nillableDictionary["portMode"] = self.portMode
        nillableDictionary["portName"] = self.portName
        nillableDictionary["portType"] = self.portType
        nillableDictionary["serialNo"] = self.serialNo
        nillableDictionary["series"] = self.series
        nillableDictionary["speed"] = self.speed
        nillableDictionary["status"] = self.status
        nillableDictionary["vlanId"] = self.vlanId
        nillableDictionary["voiceVlan"] = self.voiceVlan

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

