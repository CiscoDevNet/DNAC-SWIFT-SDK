//
// PathResponseResultResponseEgressInterface.swift
//

//

import Foundation


open class PathResponseResultResponseEgressInterface: JSONEncodable {

    public var physicalInterface: PathResponseResultResponseEgressPhysicalInterface?
    public var virtualInterface: [PathResponseResultResponseEgressPhysicalInterface]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["physicalInterface"] = self.physicalInterface?.encodeToJSON()
        nillableDictionary["virtualInterface"] = self.virtualInterface?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

