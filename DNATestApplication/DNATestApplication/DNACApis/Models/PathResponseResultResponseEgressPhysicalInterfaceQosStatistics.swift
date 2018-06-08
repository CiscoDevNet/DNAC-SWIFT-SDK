//
// PathResponseResultResponseEgressPhysicalInterfaceQosStatistics.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceQosStatistics: JSONEncodable {

    public var classMapName: String?
    public var dropRate: Int32?
    public var numBytes: Int32?
    public var numPackets: Int32?
    public var offeredRate: Int32?
    public var queueBandwidthbps: String?
    public var queueDepth: Int32?
    public var queueNoBufferDrops: Int32?
    public var queueTotalDrops: Int32?
    public var refreshedAt: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["classMapName"] = self.classMapName
        nillableDictionary["dropRate"] = self.dropRate?.encodeToJSON()
        nillableDictionary["numBytes"] = self.numBytes?.encodeToJSON()
        nillableDictionary["numPackets"] = self.numPackets?.encodeToJSON()
        nillableDictionary["offeredRate"] = self.offeredRate?.encodeToJSON()
        nillableDictionary["queueBandwidthbps"] = self.queueBandwidthbps
        nillableDictionary["queueDepth"] = self.queueDepth?.encodeToJSON()
        nillableDictionary["queueNoBufferDrops"] = self.queueNoBufferDrops?.encodeToJSON()
        nillableDictionary["queueTotalDrops"] = self.queueTotalDrops?.encodeToJSON()
        nillableDictionary["refreshedAt"] = self.refreshedAt?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

