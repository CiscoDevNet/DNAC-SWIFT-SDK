//
// DeviceInnerHistoryTaskInfo.swift
//

//

import Foundation


open class DeviceInnerHistoryTaskInfo: JSONEncodable {

    public var addnDetails: [ResetRequestConfigParameters]?
    public var name: String?
    public var timeTaken: Int32?
    public var type: String?
    public var workItemList: [DeviceInnerHistoryTaskInfoWorkItemList]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["addnDetails"] = self.addnDetails?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["timeTaken"] = self.timeTaken?.encodeToJSON()
        nillableDictionary["type"] = self.type
        nillableDictionary["workItemList"] = self.workItemList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

