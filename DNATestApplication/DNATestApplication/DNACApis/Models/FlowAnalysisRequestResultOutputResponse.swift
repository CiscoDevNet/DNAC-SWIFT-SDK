//
// FlowAnalysisRequestResultOutputResponse.swift
//

//

import Foundation


open class FlowAnalysisRequestResultOutputResponse: JSONEncodable {

    public var flowAnalysisId: String?
    public var taskId: String?
    public var url: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["flowAnalysisId"] = self.flowAnalysisId
        nillableDictionary["taskId"] = self.taskId
        nillableDictionary["url"] = self.url

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

