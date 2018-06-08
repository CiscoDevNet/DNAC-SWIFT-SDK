//
// PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts: JSONEncodable {

    public var destPorts: [String]?
    public var sourcePorts: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["destPorts"] = self.destPorts?.encodeToJSON()
        nillableDictionary["sourcePorts"] = self.sourcePorts?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

