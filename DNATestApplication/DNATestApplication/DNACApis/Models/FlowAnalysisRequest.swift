//
// FlowAnalysisRequest.swift
//

//

import Foundation


open class FlowAnalysisRequest: JSONEncodable {

    public var controlPath: Bool?
    public var destIP: String?
    public var destPort: String?
    public var inclusions: [String]?
    public var periodicRefresh: Bool?
    public var _protocol: String?
    public var sourceIP: String?
    public var sourcePort: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["controlPath"] = self.controlPath
        nillableDictionary["destIP"] = self.destIP
        nillableDictionary["destPort"] = self.destPort
        nillableDictionary["inclusions"] = self.inclusions?.encodeToJSON()
        nillableDictionary["periodicRefresh"] = self.periodicRefresh
        nillableDictionary["protocol"] = self._protocol
        nillableDictionary["sourceIP"] = self.sourceIP
        nillableDictionary["sourcePort"] = self.sourcePort

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

