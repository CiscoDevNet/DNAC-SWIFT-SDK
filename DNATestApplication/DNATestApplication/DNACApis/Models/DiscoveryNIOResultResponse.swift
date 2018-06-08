//
// DiscoveryNIOResultResponse.swift
//

//

import Foundation


open class DiscoveryNIOResultResponse: JSONEncodable {

    public var attributeInfo: Any?
    public var cdpLevel: Int32?
    public var deviceIds: String?
    public var discoveryCondition: String?
    public var discoveryStatus: String?
    public var discoveryType: String?
    public var enablePasswordList: String?
    public var globalCredentialIdList: [String]?
    public var httpReadCredential: HTTPReadCredentialDTOInner?
    public var httpWriteCredential: HTTPReadCredentialDTOInner?
    public var id: String?
    public var ipAddressList: String?
    public var ipFilterList: String?
    public var isAutoCdp: Bool?
    public var lldpLevel: Int32?
    public var name: String?
    public var netconfPort: String?
    public var numDevices: Int32?
    public var parentDiscoveryId: String?
    public var passwordList: String?
    public var preferredMgmtIPMethod: String?
    public var protocolOrder: String?
    public var retryCount: Int32?
    public var snmpAuthPassphrase: String?
    public var snmpAuthProtocol: String?
    public var snmpMode: String?
    public var snmpPrivPassphrase: String?
    public var snmpPrivProtocol: String?
    public var snmpRoCommunity: String?
    public var snmpRoCommunityDesc: String?
    public var snmpRwCommunity: String?
    public var snmpRwCommunityDesc: String?
    public var snmpUserName: String?
    public var timeOut: Int32?
    public var updateMgmtIp: Bool?
    public var userNameList: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["cdpLevel"] = self.cdpLevel?.encodeToJSON()
        nillableDictionary["deviceIds"] = self.deviceIds
        nillableDictionary["discoveryCondition"] = self.discoveryCondition
        nillableDictionary["discoveryStatus"] = self.discoveryStatus
        nillableDictionary["discoveryType"] = self.discoveryType
        nillableDictionary["enablePasswordList"] = self.enablePasswordList
        nillableDictionary["globalCredentialIdList"] = self.globalCredentialIdList?.encodeToJSON()
        nillableDictionary["httpReadCredential"] = self.httpReadCredential?.encodeToJSON()
        nillableDictionary["httpWriteCredential"] = self.httpWriteCredential?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["ipAddressList"] = self.ipAddressList
        nillableDictionary["ipFilterList"] = self.ipFilterList
        nillableDictionary["isAutoCdp"] = self.isAutoCdp
        nillableDictionary["lldpLevel"] = self.lldpLevel?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["netconfPort"] = self.netconfPort
        nillableDictionary["numDevices"] = self.numDevices?.encodeToJSON()
        nillableDictionary["parentDiscoveryId"] = self.parentDiscoveryId
        nillableDictionary["passwordList"] = self.passwordList
        nillableDictionary["preferredMgmtIPMethod"] = self.preferredMgmtIPMethod
        nillableDictionary["protocolOrder"] = self.protocolOrder
        nillableDictionary["retryCount"] = self.retryCount?.encodeToJSON()
        nillableDictionary["snmpAuthPassphrase"] = self.snmpAuthPassphrase
        nillableDictionary["snmpAuthProtocol"] = self.snmpAuthProtocol
        nillableDictionary["snmpMode"] = self.snmpMode
        nillableDictionary["snmpPrivPassphrase"] = self.snmpPrivPassphrase
        nillableDictionary["snmpPrivProtocol"] = self.snmpPrivProtocol
        nillableDictionary["snmpRoCommunity"] = self.snmpRoCommunity
        nillableDictionary["snmpRoCommunityDesc"] = self.snmpRoCommunityDesc
        nillableDictionary["snmpRwCommunity"] = self.snmpRwCommunity
        nillableDictionary["snmpRwCommunityDesc"] = self.snmpRwCommunityDesc
        nillableDictionary["snmpUserName"] = self.snmpUserName
        nillableDictionary["timeOut"] = self.timeOut?.encodeToJSON()
        nillableDictionary["updateMgmtIp"] = self.updateMgmtIp
        nillableDictionary["userNameList"] = self.userNameList

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

