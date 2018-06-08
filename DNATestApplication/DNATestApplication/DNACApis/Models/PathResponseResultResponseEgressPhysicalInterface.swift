//
// PathResponseResultResponseEgressPhysicalInterface.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterface: JSONEncodable {

    public var aclAnalysis: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis?
    public var id: String?
    public var interfaceStatistics: PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics?
    public var interfaceStatsCollection: String?
    public var interfaceStatsCollectionFailureReason: String?
    public var name: String?
    public var pathOverlayInfo: [PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo]?
    public var qosStatistics: [PathResponseResultResponseEgressPhysicalInterfaceQosStatistics]?
    public var qosStatsCollection: String?
    public var qosStatsCollectionFailureReason: String?
    public var usedVlan: String?
    public var vrfName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["aclAnalysis"] = self.aclAnalysis?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["interfaceStatistics"] = self.interfaceStatistics?.encodeToJSON()
        nillableDictionary["interfaceStatsCollection"] = self.interfaceStatsCollection
        nillableDictionary["interfaceStatsCollectionFailureReason"] = self.interfaceStatsCollectionFailureReason
        nillableDictionary["name"] = self.name
        nillableDictionary["pathOverlayInfo"] = self.pathOverlayInfo?.encodeToJSON()
        nillableDictionary["qosStatistics"] = self.qosStatistics?.encodeToJSON()
        nillableDictionary["qosStatsCollection"] = self.qosStatsCollection
        nillableDictionary["qosStatsCollectionFailureReason"] = self.qosStatsCollectionFailureReason
        nillableDictionary["usedVlan"] = self.usedVlan
        nillableDictionary["vrfName"] = self.vrfName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

