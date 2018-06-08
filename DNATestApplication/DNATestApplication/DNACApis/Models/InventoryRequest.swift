//
// InventoryRequest.swift
//

//

import Foundation


open class InventoryRequest: JSONEncodable {

    public var cdpLevel: Int32?
    public var discoveryType: String?
    public var enablePasswordList: [String]?
    public var globalCredentialIdList: [String]?
    public var httpReadCredential: HTTPReadCredentialDTOInner?
    public var httpWriteCredential: HTTPReadCredentialDTOInner?
    public var ipAddressList: String?
    public var ipFilterList: [String]?
    public var lldpLevel: Int32?
    public var name: String?
    public var netconfPort: String?
    public var noAddNewDevice: Bool?
    public var parentDiscoveryId: String?
    public var passwordList: [String]?
    public var preferredMgmtIPMethod: String?
    public var protocolOrder: String?
    public var reDiscovery: Bool?
    public var retry: Int32?
    public var snmpAuthPassphrase: String?
    public var snmpAuthProtocol: String?
    public var snmpMode: String?
    public var snmpPrivPassphrase: String?
    public var snmpPrivProtocol: String?
    public var snmpROCommunity: String?
    public var snmpROCommunityDesc: String?
    public var snmpRWCommunity: String?
    public var snmpRWCommunityDesc: String?
    public var snmpUserName: String?
    public var snmpVersion: String?
    public var timeout: Int32?
    public var updateMgmtIp: Bool?
    public var userNameList: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cdpLevel"] = self.cdpLevel?.encodeToJSON()
        nillableDictionary["discoveryType"] = self.discoveryType
        nillableDictionary["enablePasswordList"] = self.enablePasswordList?.encodeToJSON()
        nillableDictionary["globalCredentialIdList"] = self.globalCredentialIdList?.encodeToJSON()
        nillableDictionary["httpReadCredential"] = self.httpReadCredential?.encodeToJSON()
        nillableDictionary["httpWriteCredential"] = self.httpWriteCredential?.encodeToJSON()
        nillableDictionary["ipAddressList"] = self.ipAddressList
        nillableDictionary["ipFilterList"] = self.ipFilterList?.encodeToJSON()
        nillableDictionary["lldpLevel"] = self.lldpLevel?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["netconfPort"] = self.netconfPort
        nillableDictionary["noAddNewDevice"] = self.noAddNewDevice
        nillableDictionary["parentDiscoveryId"] = self.parentDiscoveryId
        nillableDictionary["passwordList"] = self.passwordList?.encodeToJSON()
        nillableDictionary["preferredMgmtIPMethod"] = self.preferredMgmtIPMethod
        nillableDictionary["protocolOrder"] = self.protocolOrder
        nillableDictionary["reDiscovery"] = self.reDiscovery
        nillableDictionary["retry"] = self.retry?.encodeToJSON()
        nillableDictionary["snmpAuthPassphrase"] = self.snmpAuthPassphrase
        nillableDictionary["snmpAuthProtocol"] = self.snmpAuthProtocol
        nillableDictionary["snmpMode"] = self.snmpMode
        nillableDictionary["snmpPrivPassphrase"] = self.snmpPrivPassphrase
        nillableDictionary["snmpPrivProtocol"] = self.snmpPrivProtocol
        nillableDictionary["snmpROCommunity"] = self.snmpROCommunity
        nillableDictionary["snmpROCommunityDesc"] = self.snmpROCommunityDesc
        nillableDictionary["snmpRWCommunity"] = self.snmpRWCommunity
        nillableDictionary["snmpRWCommunityDesc"] = self.snmpRWCommunityDesc
        nillableDictionary["snmpUserName"] = self.snmpUserName
        nillableDictionary["snmpVersion"] = self.snmpVersion
        nillableDictionary["timeout"] = self.timeout?.encodeToJSON()
        nillableDictionary["updateMgmtIp"] = self.updateMgmtIp
        nillableDictionary["userNameList"] = self.userNameList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

