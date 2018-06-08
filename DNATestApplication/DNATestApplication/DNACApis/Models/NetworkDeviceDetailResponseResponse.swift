//
// NetworkDeviceDetailResponseResponse.swift
//

//

import Foundation


open class NetworkDeviceDetailResponseResponse: JSONEncodable {

    public var managementIpAddr: String?
    public var serialNumber: String?
    public var nwDeviceName: String?
    public var opState: String?
    public var platformId: String?
    public var nwDeviceId: String?
    public var sysUptime: String?
    public var mode: String?
    public var resetReason: String?
    public var nwDeviceRole: String?
    public var upTime: String?
    public var nwDeviceFamily: String?
    public var macAddress: String?
    public var connectedTime: String?
    public var softwareVersion: String?
    public var subMode: String?
    public var nwDeviceType: String?
    public var overallHealth: String?
    public var memoryScore: String?
    public var cpuScore: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["managementIpAddr"] = self.managementIpAddr
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["nwDeviceName"] = self.nwDeviceName
        nillableDictionary["opState"] = self.opState
        nillableDictionary["platformId"] = self.platformId
        nillableDictionary["nwDeviceId"] = self.nwDeviceId
        nillableDictionary["sysUptime"] = self.sysUptime
        nillableDictionary["mode"] = self.mode
        nillableDictionary["resetReason"] = self.resetReason
        nillableDictionary["nwDeviceRole"] = self.nwDeviceRole
        nillableDictionary["upTime"] = self.upTime
        nillableDictionary["nwDeviceFamily"] = self.nwDeviceFamily
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["connectedTime"] = self.connectedTime
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["subMode"] = self.subMode
        nillableDictionary["nwDeviceType"] = self.nwDeviceType
        nillableDictionary["overallHealth"] = self.overallHealth
        nillableDictionary["memoryScore"] = self.memoryScore
        nillableDictionary["cpuScore"] = self.cpuScore

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

