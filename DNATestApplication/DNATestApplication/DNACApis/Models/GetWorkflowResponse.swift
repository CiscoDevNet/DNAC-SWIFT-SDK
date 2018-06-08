//
// GetWorkflowResponse.swift
//

//

import Foundation


open class GetWorkflowResponse: JSONEncodable {


    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

