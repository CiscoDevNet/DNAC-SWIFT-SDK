//
// TopologyResultResponseNodes.swift
//

//

import Foundation


open class TopologyResultResponseNodes: JSONEncodable {

    public var aclApplied: Bool?
    public var additionalInfo: Any?
    public var customParam: TopologyResultResponseCustomParam?
    public var dataPathId: String?
    public var deviceType: String?
    public var family: String?
    public var fixed: Bool?
    public var greyOut: Bool?
    public var id: String?
    public var ip: String?
    public var label: String?
    public var networkType: String?
    public var nodeType: String?
    public var order: Int32?
    public var osType: String?
    public var platformId: String?
    public var role: String?
    public var roleSource: String?
    public var softwareVersion: String?
    public var tags: [String]?
    public var upperNode: String?
    public var userId: String?
    public var vlanId: String?
    public var x: Int32?
    public var y: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["aclApplied"] = self.aclApplied
        nillableDictionary["additionalInfo"] = self.additionalInfo
        nillableDictionary["customParam"] = self.customParam?.encodeToJSON()
        nillableDictionary["dataPathId"] = self.dataPathId
        nillableDictionary["deviceType"] = self.deviceType
        nillableDictionary["family"] = self.family
        nillableDictionary["fixed"] = self.fixed
        nillableDictionary["greyOut"] = self.greyOut
        nillableDictionary["id"] = self.id
        nillableDictionary["ip"] = self.ip
        nillableDictionary["label"] = self.label
        nillableDictionary["networkType"] = self.networkType
        nillableDictionary["nodeType"] = self.nodeType
        nillableDictionary["order"] = self.order?.encodeToJSON()
        nillableDictionary["osType"] = self.osType
        nillableDictionary["platformId"] = self.platformId
        nillableDictionary["role"] = self.role
        nillableDictionary["roleSource"] = self.roleSource
        nillableDictionary["softwareVersion"] = self.softwareVersion
        nillableDictionary["tags"] = self.tags?.encodeToJSON()
        nillableDictionary["upperNode"] = self.upperNode
        nillableDictionary["userId"] = self.userId
        nillableDictionary["vlanId"] = self.vlanId
        nillableDictionary["x"] = self.x?.encodeToJSON()
        nillableDictionary["y"] = self.y?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

