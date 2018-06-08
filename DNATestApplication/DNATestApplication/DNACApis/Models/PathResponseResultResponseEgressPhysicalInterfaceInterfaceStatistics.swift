//
// PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics: JSONEncodable {

    public var adminStatus: String?
    public var inputPackets: Int32?
    public var inputQueueCount: Int32?
    public var inputQueueDrops: Int32?
    public var inputQueueFlushes: Int32?
    public var inputQueueMaxDepth: Int32?
    public var inputRatebps: Int32?
    public var operationalStatus: String?
    public var outputDrop: Int32?
    public var outputPackets: Int32?
    public var outputQueueCount: Int32?
    public var outputQueueDepth: Int32?
    public var outputRatebps: Int32?
    public var refreshedAt: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["adminStatus"] = self.adminStatus
        nillableDictionary["inputPackets"] = self.inputPackets?.encodeToJSON()
        nillableDictionary["inputQueueCount"] = self.inputQueueCount?.encodeToJSON()
        nillableDictionary["inputQueueDrops"] = self.inputQueueDrops?.encodeToJSON()
        nillableDictionary["inputQueueFlushes"] = self.inputQueueFlushes?.encodeToJSON()
        nillableDictionary["inputQueueMaxDepth"] = self.inputQueueMaxDepth?.encodeToJSON()
        nillableDictionary["inputRatebps"] = self.inputRatebps?.encodeToJSON()
        nillableDictionary["operationalStatus"] = self.operationalStatus
        nillableDictionary["outputDrop"] = self.outputDrop?.encodeToJSON()
        nillableDictionary["outputPackets"] = self.outputPackets?.encodeToJSON()
        nillableDictionary["outputQueueCount"] = self.outputQueueCount?.encodeToJSON()
        nillableDictionary["outputQueueDepth"] = self.outputQueueDepth?.encodeToJSON()
        nillableDictionary["outputRatebps"] = self.outputRatebps?.encodeToJSON()
        nillableDictionary["refreshedAt"] = self.refreshedAt?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

