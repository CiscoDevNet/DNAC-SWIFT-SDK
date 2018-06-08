//
// PathResponseResultResponseAccuracyList.swift
//

//

import Foundation


open class PathResponseResultResponseAccuracyList: JSONEncodable {

    public var percent: Int32?
    public var reason: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["percent"] = self.percent?.encodeToJSON()
        nillableDictionary["reason"] = self.reason

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

