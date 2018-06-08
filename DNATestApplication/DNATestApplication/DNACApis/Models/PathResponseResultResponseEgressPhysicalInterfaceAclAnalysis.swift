//
// PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis.swift
//

//

import Foundation


open class PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis: JSONEncodable {

    public var aclName: String?
    public var matchingAces: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces]?
    public var result: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["aclName"] = self.aclName
        nillableDictionary["matchingAces"] = self.matchingAces?.encodeToJSON()
        nillableDictionary["result"] = self.result

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

