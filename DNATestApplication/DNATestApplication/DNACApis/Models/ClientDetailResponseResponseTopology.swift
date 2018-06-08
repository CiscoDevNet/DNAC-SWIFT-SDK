//
// ClientDetailResponseResponseTopology.swift
//

//

import Foundation


open class ClientDetailResponseResponseTopology: JSONEncodable {

    public var nodes: [ClientDetailResponseResponseTopologyNodes]?
    public var links: [ClientDetailResponseResponseTopologyLinks]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["nodes"] = self.nodes?.encodeToJSON()
        nillableDictionary["links"] = self.links?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

