//
// DeviceInnerDeviceInfoStackInfoStackMemberList.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoStackInfoStackMemberList: JSONEncodable {

    public var hardwareVersion: String?
    public var licenseLevel: String?
    public var licenseType: String?
    public var macAddress: String?
    public var pid: String?
    public var priority: Int32?
    public var role: String?
    public var serialNumber: String?
    public var softwareVersion: String?
    public var stackNumber: Int32?
    public var state: String?
    public var sudiSerialNumber: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["hardwareVersion"] = self.hardwareVersion
        nillableDictionary["licenseLevel"] = self.licenseLevel
        nillableDictionary["licenseType"] = self.licenseType
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["pid"] = self.pid
        nillableDictionary["priority"] = self.priority?.encodeToJSON()
        nillableDictionary["role"] = self.role
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["stackNumber"] = self.stackNumber?.encodeToJSON()
        nillableDictionary["state"] = self.state
        nillableDictionary["sudiSerialNumber"] = self.sudiSerialNumber

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

