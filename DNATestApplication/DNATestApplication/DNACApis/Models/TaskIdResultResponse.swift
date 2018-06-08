//
// TaskIdResultResponse.swift
//

//

import Foundation


open class TaskIdResultResponse: JSONEncodable {

    public var taskId: Any?
    public var url: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["taskId"] = self.taskId
        nillableDictionary["url"] = self.url

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

