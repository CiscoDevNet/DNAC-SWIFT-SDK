//
// DeviceInnerRunSummaryList.swift
//

//

import Foundation


open class DeviceInnerRunSummaryList: JSONEncodable {

    public var details: String?
    public var errorFlag: Bool?
    public var historyTaskInfo: DeviceInnerHistoryTaskInfo?
    public var timestamp: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["details"] = self.details
        nillableDictionary["errorFlag"] = self.errorFlag
        nillableDictionary["historyTaskInfo"] = self.historyTaskInfo?.encodeToJSON()
        nillableDictionary["timestamp"] = self.timestamp?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

