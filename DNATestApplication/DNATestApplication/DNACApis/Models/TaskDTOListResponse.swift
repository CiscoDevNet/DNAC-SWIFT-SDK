//
// TaskDTOListResponse.swift
//

//

import Foundation


open class TaskDTOListResponse: JSONEncodable {

    public var response: [TaskDTOResponseResponse]?
    public var version: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["response"] = self.response?.encodeToJSON()
        nillableDictionary["version"] = self.version

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

