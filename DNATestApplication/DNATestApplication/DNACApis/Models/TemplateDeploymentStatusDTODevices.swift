//
// TemplateDeploymentStatusDTODevices.swift
//

//

import Foundation


open class TemplateDeploymentStatusDTODevices: JSONEncodable {

    public var deviceId: String?
    public var duration: String?
    public var endTime: String?
    public var ipAddress: String?
    public var name: String?
    public var startTime: String?
    public var status: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceId"] = self.deviceId
        nillableDictionary["duration"] = self.duration
        nillableDictionary["endTime"] = self.endTime
        nillableDictionary["ipAddress"] = self.ipAddress
        nillableDictionary["name"] = self.name
        nillableDictionary["startTime"] = self.startTime
        nillableDictionary["status"] = self.status

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

