//
// UnclaimRequest.swift
//

//

import Foundation


open class UnclaimRequest: JSONEncodable {

    public var deviceIdList: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceIdList"] = self.deviceIdList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

