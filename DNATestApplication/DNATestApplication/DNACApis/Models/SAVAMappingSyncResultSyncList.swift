//
// SAVAMappingSyncResultSyncList.swift
//

//

import Foundation


open class SAVAMappingSyncResultSyncList: JSONEncodable {

    public enum SyncType: String { 
        case add = "Add"
        case update = "Update"
        case delete = "Delete"
        case mismatchError = "MismatchError"
    }
    public var deviceSnList: [String]?
    public var syncType: SyncType?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceSnList"] = self.deviceSnList?.encodeToJSON()
        nillableDictionary["syncType"] = self.syncType?.rawValue

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

