//
// TopologyResultResponseCustomParam.swift
//

//

import Foundation


open class TopologyResultResponseCustomParam: JSONEncodable {

    public var id: String?
    public var label: String?
    public var parentNodeId: String?
    public var x: Int32?
    public var y: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["label"] = self.label
        nillableDictionary["parentNodeId"] = self.parentNodeId
        nillableDictionary["x"] = self.x?.encodeToJSON()
        nillableDictionary["y"] = self.y?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

