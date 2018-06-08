//
// PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces: JSONEncodable {

    public var ace: String?
    public var matchingPorts: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts]?
    public var result: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["ace"] = self.ace
        nillableDictionary["matchingPorts"] = self.matchingPorts?.encodeToJSON()
        nillableDictionary["result"] = self.result

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

