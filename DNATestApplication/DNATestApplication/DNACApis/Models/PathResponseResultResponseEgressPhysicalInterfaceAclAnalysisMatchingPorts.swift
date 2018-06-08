//
// PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts: JSONEncodable {

    public var ports: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts]?
    public var _protocol: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["ports"] = self.ports?.encodeToJSON()
        nillableDictionary["protocol"] = self._protocol

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

