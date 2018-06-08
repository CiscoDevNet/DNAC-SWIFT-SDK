//
// TopologyResultResponseLinks.swift
//

//

import Foundation


open class TopologyResultResponseLinks: JSONEncodable {

    public var additionalInfo: Any?
    public var endPortID: String?
    public var endPortIpv4Address: String?
    public var endPortIpv4Mask: String?
    public var endPortName: String?
    public var endPortSpeed: String?
    public var greyOut: Bool?
    public var id: String?
    public var linkStatus: String?
    public var source: String?
    public var startPortID: String?
    public var startPortIpv4Address: String?
    public var startPortIpv4Mask: String?
    public var startPortName: String?
    public var startPortSpeed: String?
    public var tag: String?
    public var target: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["additionalInfo"] = self.additionalInfo
        nillableDictionary["endPortID"] = self.endPortID
        nillableDictionary["endPortIpv4Address"] = self.endPortIpv4Address
        nillableDictionary["endPortIpv4Mask"] = self.endPortIpv4Mask
        nillableDictionary["endPortName"] = self.endPortName
        nillableDictionary["endPortSpeed"] = self.endPortSpeed
        nillableDictionary["greyOut"] = self.greyOut
        nillableDictionary["id"] = self.id
        nillableDictionary["linkStatus"] = self.linkStatus
        nillableDictionary["source"] = self.source
        nillableDictionary["startPortID"] = self.startPortID
        nillableDictionary["startPortIpv4Address"] = self.startPortIpv4Address
        nillableDictionary["startPortIpv4Mask"] = self.startPortIpv4Mask
        nillableDictionary["startPortName"] = self.startPortName
        nillableDictionary["startPortSpeed"] = self.startPortSpeed
        nillableDictionary["tag"] = self.tag
        nillableDictionary["target"] = self.target

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

