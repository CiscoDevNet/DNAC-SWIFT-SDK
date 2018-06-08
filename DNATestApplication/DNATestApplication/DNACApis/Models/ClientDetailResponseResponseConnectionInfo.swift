//
// ClientDetailResponseResponseConnectionInfo.swift
//

//

import Foundation


open class ClientDetailResponseResponseConnectionInfo: JSONEncodable {

    public var hostType: String?
    public var nwDeviceName: String?
    public var nwDeviceMac: String?
    public var _protocol: String?
    public var band: String?
    public var spatialStream: String?
    public var channel: String?
    public var channelWidth: String?
    public var wmm: String?
    public var uapsd: String?
    public var timestamp: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["hostType"] = self.hostType
        nillableDictionary["nwDeviceName"] = self.nwDeviceName
        nillableDictionary["nwDeviceMac"] = self.nwDeviceMac
        nillableDictionary["protocol"] = self._protocol
        nillableDictionary["band"] = self.band
        nillableDictionary["spatialStream"] = self.spatialStream
        nillableDictionary["channel"] = self.channel
        nillableDictionary["channelWidth"] = self.channelWidth
        nillableDictionary["wmm"] = self.wmm
        nillableDictionary["uapsd"] = self.uapsd
        nillableDictionary["timestamp"] = self.timestamp

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

