//
// TopologyResultResponse.swift
//

//

import Foundation


open class TopologyResultResponse: JSONEncodable {

    public var id: String?
    public var links: [TopologyResultResponseLinks]?
    public var nodes: [TopologyResultResponseNodes]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["links"] = self.links?.encodeToJSON()
        nillableDictionary["nodes"] = self.nodes?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

