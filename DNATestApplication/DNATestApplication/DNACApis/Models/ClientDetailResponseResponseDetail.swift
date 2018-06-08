//
// ClientDetailResponseResponseDetail.swift
//

//

import Foundation


open class ClientDetailResponseResponseDetail: JSONEncodable {

    public var id: String?
    public var connectionStatus: String?
    public var hostType: String?
    public var userId: String?
    public var hostName: String?
    public var hostOs: String?
    public var hostVersion: String?
    public var subType: String?
    public var lastUpdated: String?
    public var healthScore: [ClientDetailResponseResponseDetailHealthScore]?
    public var hostMac: String?
    public var hostIpV4: String?
    public var hostIpV6: [String]?
    public var authType: String?
    public var vlanId: String?
    public var ssid: String?
    public var frequency: String?
    public var channel: String?
    public var apGroup: String?
    public var location: String?
    public var clientConnection: String?
    public var connectedDevice: [String]?
    public var issueCount: String?
    public var rssi: String?
    public var avgRssi: String?
    public var snr: String?
    public var avgSnr: String?
    public var dataRate: String?
    public var txBytes: String?
    public var rxBytes: String?
    public var dnsSuccess: String?
    public var dnsFailure: String?
    public var onboarding: ClientDetailResponseResponseDetailOnboarding?
    public var onboardingTime: String?
    public var port: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["connectionStatus"] = self.connectionStatus
        nillableDictionary["hostType"] = self.hostType
        nillableDictionary["userId"] = self.userId
        nillableDictionary["hostName"] = self.hostName
        nillableDictionary["hostOs"] = self.hostOs
        nillableDictionary["hostVersion"] = self.hostVersion
        nillableDictionary["subType"] = self.subType
        nillableDictionary["lastUpdated"] = self.lastUpdated
        nillableDictionary["healthScore"] = self.healthScore?.encodeToJSON()
        nillableDictionary["hostMac"] = self.hostMac
        nillableDictionary["hostIpV4"] = self.hostIpV4
        nillableDictionary["hostIpV6"] = self.hostIpV6?.encodeToJSON()
        nillableDictionary["authType"] = self.authType
        nillableDictionary["vlanId"] = self.vlanId
        nillableDictionary["ssid"] = self.ssid
        nillableDictionary["frequency"] = self.frequency
        nillableDictionary["channel"] = self.channel
        nillableDictionary["apGroup"] = self.apGroup
        nillableDictionary["location"] = self.location
        nillableDictionary["clientConnection"] = self.clientConnection
        nillableDictionary["connectedDevice"] = self.connectedDevice?.encodeToJSON()
        nillableDictionary["issueCount"] = self.issueCount
        nillableDictionary["rssi"] = self.rssi
        nillableDictionary["avgRssi"] = self.avgRssi
        nillableDictionary["snr"] = self.snr
        nillableDictionary["avgSnr"] = self.avgSnr
        nillableDictionary["dataRate"] = self.dataRate
        nillableDictionary["txBytes"] = self.txBytes
        nillableDictionary["rxBytes"] = self.rxBytes
        nillableDictionary["dnsSuccess"] = self.dnsSuccess
        nillableDictionary["dnsFailure"] = self.dnsFailure
        nillableDictionary["onboarding"] = self.onboarding?.encodeToJSON()
        nillableDictionary["onboardingTime"] = self.onboardingTime
        nillableDictionary["port"] = self.port

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

