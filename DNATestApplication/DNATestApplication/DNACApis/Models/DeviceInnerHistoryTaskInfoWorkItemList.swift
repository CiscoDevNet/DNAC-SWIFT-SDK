//
// DeviceInnerHistoryTaskInfoWorkItemList.swift
//

//

import Foundation


open class DeviceInnerHistoryTaskInfoWorkItemList: JSONEncodable {

    public var command: String?
    public var endTime: Int32?
    public var outputStr: String?
    public var startTime: Int32?
    public var state: String?
    public var timeTaken: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["command"] = self.command
        nillableDictionary["endTime"] = self.endTime?.encodeToJSON()
        nillableDictionary["outputStr"] = self.outputStr
        nillableDictionary["startTime"] = self.startTime?.encodeToJSON()
        nillableDictionary["state"] = self.state
        nillableDictionary["timeTaken"] = self.timeTaken?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

