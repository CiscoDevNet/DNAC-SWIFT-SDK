//
// RawCliInfoNIOListResultResponse.swift
//

//

import Foundation


open class RawCliInfoNIOListResultResponse: JSONEncodable {

    public var attributeInfo: Any?
    public var cdpNeighbors: String?
    public var healthMonitor: String?
    public var id: String?
    public var intfDescription: String?
    public var inventory: String?
    public var ipIntfBrief: String?
    public var macAddressTable: String?
    public var runningConfig: String?
    public var snmp: String?
    public var version: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["cdpNeighbors"] = self.cdpNeighbors
        nillableDictionary["healthMonitor"] = self.healthMonitor
        nillableDictionary["id"] = self.id
        nillableDictionary["intfDescription"] = self.intfDescription
        nillableDictionary["inventory"] = self.inventory
        nillableDictionary["ipIntfBrief"] = self.ipIntfBrief
        nillableDictionary["macAddressTable"] = self.macAddressTable
        nillableDictionary["runningConfig"] = self.runningConfig
        nillableDictionary["snmp"] = self.snmp
        nillableDictionary["version"] = self.version

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

