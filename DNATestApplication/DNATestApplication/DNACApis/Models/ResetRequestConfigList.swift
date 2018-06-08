//
// ResetRequestConfigList.swift
//

//

import Foundation


open class ResetRequestConfigList: JSONEncodable {

    public var configId: String?
    public var configParameters: [ResetRequestConfigParameters]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["configId"] = self.configId
        nillableDictionary["configParameters"] = self.configParameters?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

