//
// PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo: JSONEncodable {

    public var controlPlane: String?
    public var dataPacketEncapsulation: String?
    public var destIp: String?
    public var destPort: String?
    public var _protocol: String?
    public var sourceIp: String?
    public var sourcePort: String?
    public var vxlanInfo: PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["controlPlane"] = self.controlPlane
        nillableDictionary["dataPacketEncapsulation"] = self.dataPacketEncapsulation
        nillableDictionary["destIp"] = self.destIp
        nillableDictionary["destPort"] = self.destPort
        nillableDictionary["protocol"] = self._protocol
        nillableDictionary["sourceIp"] = self.sourceIp
        nillableDictionary["sourcePort"] = self.sourcePort
        nillableDictionary["vxlanInfo"] = self.vxlanInfo?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

