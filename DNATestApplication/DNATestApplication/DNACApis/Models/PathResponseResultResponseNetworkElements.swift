//
// PathResponseResultResponseNetworkElements.swift
//

//

import Foundation


open class PathResponseResultResponseNetworkElements: JSONEncodable {

    public var accuracyList: [PathResponseResultResponseAccuracyList]?
    public var detailedStatus: PathResponseResultResponseDetailedStatus?
    public var deviceStatistics: PathResponseResultResponseDeviceStatistics?
    public var deviceStatsCollection: String?
    public var deviceStatsCollectionFailureReason: String?
    public var egressPhysicalInterface: PathResponseResultResponseEgressPhysicalInterface?
    public var egressVirtualInterface: PathResponseResultResponseEgressPhysicalInterface?
    public var flexConnect: PathResponseResultResponseFlexConnect?
    public var id: String?
    public var ingressPhysicalInterface: PathResponseResultResponseEgressPhysicalInterface?
    public var ingressVirtualInterface: PathResponseResultResponseEgressPhysicalInterface?
    public var ip: String?
    public var linkInformationSource: String?
    public var name: String?
    public var perfMonCollection: String?
    public var perfMonCollectionFailureReason: String?
    public var perfMonStatistics: [PathResponseResultResponsePerfMonStatistics]?
    public var role: String?
    public var ssid: String?
    public var tunnels: [String]?
    public var type: String?
    public var wlanId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["accuracyList"] = self.accuracyList?.encodeToJSON()
        nillableDictionary["detailedStatus"] = self.detailedStatus?.encodeToJSON()
        nillableDictionary["deviceStatistics"] = self.deviceStatistics?.encodeToJSON()
        nillableDictionary["deviceStatsCollection"] = self.deviceStatsCollection
        nillableDictionary["deviceStatsCollectionFailureReason"] = self.deviceStatsCollectionFailureReason
        nillableDictionary["egressPhysicalInterface"] = self.egressPhysicalInterface?.encodeToJSON()
        nillableDictionary["egressVirtualInterface"] = self.egressVirtualInterface?.encodeToJSON()
        nillableDictionary["flexConnect"] = self.flexConnect?.encodeToJSON()
        nillableDictionary["id"] = self.id
        nillableDictionary["ingressPhysicalInterface"] = self.ingressPhysicalInterface?.encodeToJSON()
        nillableDictionary["ingressVirtualInterface"] = self.ingressVirtualInterface?.encodeToJSON()
        nillableDictionary["ip"] = self.ip
        nillableDictionary["linkInformationSource"] = self.linkInformationSource
        nillableDictionary["name"] = self.name
        nillableDictionary["perfMonCollection"] = self.perfMonCollection
        nillableDictionary["perfMonCollectionFailureReason"] = self.perfMonCollectionFailureReason
        nillableDictionary["perfMonStatistics"] = self.perfMonStatistics?.encodeToJSON()
        nillableDictionary["role"] = self.role
        nillableDictionary["ssid"] = self.ssid
        nillableDictionary["tunnels"] = self.tunnels?.encodeToJSON()
        nillableDictionary["type"] = self.type
        nillableDictionary["wlanId"] = self.wlanId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

