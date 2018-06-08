//
// PathResponseResultResponsePerfMonStatistics.swift
//

//

import Foundation


open class PathResponseResultResponsePerfMonStatistics: JSONEncodable {

    public var byteRate: Int32?
    public var destIpAddress: String?
    public var destPort: String?
    public var inputInterface: String?
    public var ipv4DSCP: String?
    public var ipv4TTL: Int32?
    public var outputInterface: String?
    public var packetBytes: Int32?
    public var packetCount: Int32?
    public var packetLoss: Int32?
    public var packetLossPercentage: Double?
    public var _protocol: String?
    public var refreshedAt: Int32?
    public var rtpJitterMax: Int32?
    public var rtpJitterMean: Int32?
    public var rtpJitterMin: Int32?
    public var sourceIpAddress: String?
    public var sourcePort: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["byteRate"] = self.byteRate?.encodeToJSON()
        nillableDictionary["destIpAddress"] = self.destIpAddress
        nillableDictionary["destPort"] = self.destPort
        nillableDictionary["inputInterface"] = self.inputInterface
        nillableDictionary["ipv4DSCP"] = self.ipv4DSCP
        nillableDictionary["ipv4TTL"] = self.ipv4TTL?.encodeToJSON()
        nillableDictionary["outputInterface"] = self.outputInterface
        nillableDictionary["packetBytes"] = self.packetBytes?.encodeToJSON()
        nillableDictionary["packetCount"] = self.packetCount?.encodeToJSON()
        nillableDictionary["packetLoss"] = self.packetLoss?.encodeToJSON()
        nillableDictionary["packetLossPercentage"] = self.packetLossPercentage
        nillableDictionary["protocol"] = self._protocol
        nillableDictionary["refreshedAt"] = self.refreshedAt?.encodeToJSON()
        nillableDictionary["rtpJitterMax"] = self.rtpJitterMax?.encodeToJSON()
        nillableDictionary["rtpJitterMean"] = self.rtpJitterMean?.encodeToJSON()
        nillableDictionary["rtpJitterMin"] = self.rtpJitterMin?.encodeToJSON()
        nillableDictionary["sourceIpAddress"] = self.sourceIpAddress
        nillableDictionary["sourcePort"] = self.sourcePort

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

