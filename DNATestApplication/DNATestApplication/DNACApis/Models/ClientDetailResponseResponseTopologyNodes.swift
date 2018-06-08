//
// ClientDetailResponseResponseTopologyNodes.swift
//

//

import Foundation


open class ClientDetailResponseResponseTopologyNodes: JSONEncodable {

    public var role: String?
    public var name: String?
    public var id: String?
    public var description: String?
    public var deviceType: String?
    public var platformId: String?
    public var family: String?
    public var ip: String?
    public var softwareVersion: String?
    public var userId: String?
    public var nodeType: String?
    public var radioFrequency: String?
    public var clients: String?
    public var count: String?
    public var healthScore: String?
    public var level: String?
    public var fabricGroup: String?
    public var connectedDevice: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["role"] = self.role
        nillableDictionary["name"] = self.name
        nillableDictionary["id"] = self.id
        nillableDictionary["description"] = self.description
        nillableDictionary["deviceType"] = self.deviceType
        nillableDictionary["platformId"] = self.platformId
        nillableDictionary["family"] = self.family
        nillableDictionary["ip"] = self.ip
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["userId"] = self.userId
        nillableDictionary["nodeType"] = self.nodeType
        nillableDictionary["radioFrequency"] = self.radioFrequency
        nillableDictionary["clients"] = self.clients
        nillableDictionary["count"] = self.count
        nillableDictionary["healthScore"] = self.healthScore
        nillableDictionary["level"] = self.level
        nillableDictionary["fabricGroup"] = self.fabricGroup
        nillableDictionary["connectedDevice"] = self.connectedDevice

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

