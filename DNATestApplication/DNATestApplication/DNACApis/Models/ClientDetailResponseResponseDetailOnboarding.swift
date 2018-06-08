//
// ClientDetailResponseResponseDetailOnboarding.swift
//

//

import Foundation


open class ClientDetailResponseResponseDetailOnboarding: JSONEncodable {

    public var averageRunDuration: String?
    public var maxRunDuration: String?
    public var averageAssocDuration: String?
    public var maxAssocDuration: String?
    public var averageAuthDuration: String?
    public var maxAuthDuration: String?
    public var averageDhcpDuration: String?
    public var maxDhcpDuration: String?
    public var aaaServerIp: String?
    public var dhcpServerIp: String?
    public var authDoneTime: String?
    public var assocDoneTime: String?
    public var dhcpDoneTime: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["averageRunDuration"] = self.averageRunDuration
        nillableDictionary["maxRunDuration"] = self.maxRunDuration
        nillableDictionary["averageAssocDuration"] = self.averageAssocDuration
        nillableDictionary["maxAssocDuration"] = self.maxAssocDuration
        nillableDictionary["averageAuthDuration"] = self.averageAuthDuration
        nillableDictionary["maxAuthDuration"] = self.maxAuthDuration
        nillableDictionary["averageDhcpDuration"] = self.averageDhcpDuration
        nillableDictionary["maxDhcpDuration"] = self.maxDhcpDuration
        nillableDictionary["aaaServerIp"] = self.aaaServerIp
        nillableDictionary["dhcpServerIp"] = self.dhcpServerIp
        nillableDictionary["authDoneTime"] = self.authDoneTime
        nillableDictionary["assocDoneTime"] = self.assocDoneTime
        nillableDictionary["dhcpDoneTime"] = self.dhcpDoneTime

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

