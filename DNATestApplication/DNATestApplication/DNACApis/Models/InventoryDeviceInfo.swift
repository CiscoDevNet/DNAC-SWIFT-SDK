//
// InventoryDeviceInfo.swift
//

//

import Foundation


open class InventoryDeviceInfo: JSONEncodable {

    public enum ModelType: String { 
        case computeDevice = "COMPUTE_DEVICE"
        case merakiDashboard = "MERAKI_DASHBOARD"
        case networkDevice = "NETWORK_DEVICE"
        case nodatachange = "NODATACHANGE"
    }
    public var cliTransport: String?
    public var computeDevice: Bool?
    public var enablePassword: String?
    public var extendedDiscoveryInfo: String?
    public var httpPassword: String?
    public var httpPort: String?
    public var httpSecure: Bool?
    public var httpUserName: String?
    public var ipAddress: [String]?
    public var merakiOrgId: [String]?
    public var netconfPort: String?
    public var password: String?
    public var serialNumber: String?
    public var snmpAuthPassphrase: String?
    public var snmpAuthProtocol: String?
    public var snmpMode: String?
    public var snmpPrivPassphrase: String?
    public var snmpPrivProtocol: String?
    public var snmpROCommunity: String?
    public var snmpRWCommunity: String?
    public var snmpRetry: Int32?
    public var snmpTimeout: Int32?
    public var snmpUserName: String?
    public var snmpVersion: String?
    public var type: ModelType?
    public var updateMgmtIPaddressList: [InventoryDeviceInfoUpdateMgmtIPaddressList]?
    public var userName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cliTransport"] = self.cliTransport
        nillableDictionary["computeDevice"] = self.computeDevice
        nillableDictionary["enablePassword"] = self.enablePassword
        nillableDictionary["extendedDiscoveryInfo"] = self.extendedDiscoveryInfo
        nillableDictionary["httpPassword"] = self.httpPassword
        nillableDictionary["httpPort"] = self.httpPort
        nillableDictionary["httpSecure"] = self.httpSecure
        nillableDictionary["httpUserName"] = self.httpUserName
        nillableDictionary["ipAddress"] = self.ipAddress?.encodeToJSON()
        nillableDictionary["merakiOrgId"] = self.merakiOrgId?.encodeToJSON()
        nillableDictionary["netconfPort"] = self.netconfPort
        nillableDictionary["password"] = self.password
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["snmpAuthPassphrase"] = self.snmpAuthPassphrase
        nillableDictionary["snmpAuthProtocol"] = self.snmpAuthProtocol
        nillableDictionary["snmpMode"] = self.snmpMode
        nillableDictionary["snmpPrivPassphrase"] = self.snmpPrivPassphrase
        nillableDictionary["snmpPrivProtocol"] = self.snmpPrivProtocol
        nillableDictionary["snmpROCommunity"] = self.snmpROCommunity
        nillableDictionary["snmpRWCommunity"] = self.snmpRWCommunity
        nillableDictionary["snmpRetry"] = self.snmpRetry?.encodeToJSON()
        nillableDictionary["snmpTimeout"] = self.snmpTimeout?.encodeToJSON()
        nillableDictionary["snmpUserName"] = self.snmpUserName
        nillableDictionary["snmpVersion"] = self.snmpVersion
        nillableDictionary["type"] = self.type?.rawValue
        nillableDictionary["updateMgmtIPaddressList"] = self.updateMgmtIPaddressList?.encodeToJSON()
        nillableDictionary["userName"] = self.userName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

