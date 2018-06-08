//
// DeviceInnerSystemResetWorkflowTasks.swift
//

//

import Foundation


open class DeviceInnerSystemResetWorkflowTasks: JSONEncodable {

    public var currWorkItemIdx: Int32?
    public var endTime: Int32?
    public var name: String?
    public var startTime: Int32?
    public var state: String?
    public var taskSeqNo: Int32?
    public var timeTaken: Int32?
    public var type: String?
    public var workItemList: [DeviceInnerHistoryTaskInfoWorkItemList]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["currWorkItemIdx"] = self.currWorkItemIdx?.encodeToJSON()
        nillableDictionary["endTime"] = self.endTime?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["startTime"] = self.startTime?.encodeToJSON()
        nillableDictionary["state"] = self.state
        nillableDictionary["taskSeqNo"] = self.taskSeqNo?.encodeToJSON()
        nillableDictionary["timeTaken"] = self.timeTaken?.encodeToJSON()
        nillableDictionary["type"] = self.type
        nillableDictionary["workItemList"] = self.workItemList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

