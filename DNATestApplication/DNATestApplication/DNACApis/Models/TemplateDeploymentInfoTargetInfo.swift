//
// TemplateDeploymentInfoTargetInfo.swift
//

//

import Foundation


open class TemplateDeploymentInfoTargetInfo: JSONEncodable {

    public enum ModelType: String { 
        case managedDeviceIp = "MANAGED_DEVICE_IP"
        case managedDeviceUuid = "MANAGED_DEVICE_UUID"
        case preProvisionedSerial = "PRE_PROVISIONED_SERIAL"
        case preProvisionedMac = "PRE_PROVISIONED_MAC"
        case _default = "DEFAULT"
        case managedDeviceHostname = "MANAGED_DEVICE_HOSTNAME"
    }
    public var hostName: String?
    public var id: String?
    public var params: Any?
    public var type: ModelType?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["hostName"] = self.hostName
        nillableDictionary["id"] = self.id
        nillableDictionary["params"] = self.params
        nillableDictionary["type"] = self.type?.rawValue

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

