//
// FlowAnalysisListOutputResponse.swift
//

//

import Foundation


open class FlowAnalysisListOutputResponse: JSONEncodable {

    public var controlPath: Bool?
    public var createTime: Int32?
    public var destIP: String?
    public var destPort: String?
    public var failureReason: String?
    public var id: String?
    public var inclusions: [String]?
    public var lastUpdateTime: Int32?
    public var periodicRefresh: Bool?
    public var _protocol: String?
    public var sourceIP: String?
    public var sourcePort: String?
    public var status: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["controlPath"] = self.controlPath
        nillableDictionary["createTime"] = self.createTime?.encodeToJSON()
        nillableDictionary["destIP"] = self.destIP
        nillableDictionary["destPort"] = self.destPort
        nillableDictionary["failureReason"] = self.failureReason
        nillableDictionary["id"] = self.id
        nillableDictionary["inclusions"] = self.inclusions?.encodeToJSON()
        nillableDictionary["lastUpdateTime"] = self.lastUpdateTime?.encodeToJSON()
        nillableDictionary["periodicRefresh"] = self.periodicRefresh
        nillableDictionary["protocol"] = self._protocol
        nillableDictionary["sourceIP"] = self.sourceIP
        nillableDictionary["sourcePort"] = self.sourcePort
        nillableDictionary["status"] = self.status

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

