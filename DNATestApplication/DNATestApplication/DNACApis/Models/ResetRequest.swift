//
// ResetRequest.swift
//

//

import Foundation


open class ResetRequest: JSONEncodable {

    public var deviceResetList: [ResetRequestDeviceResetList]?
    public var projectId: String?
    public var workflowId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceResetList"] = self.deviceResetList?.encodeToJSON()
        nillableDictionary["projectId"] = self.projectId
        nillableDictionary["workflowId"] = self.workflowId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

