//
// SAVAMappingSyncResult.swift
//

//

import Foundation


open class SAVAMappingSyncResult: JSONEncodable {

    public var syncList: [SAVAMappingSyncResultSyncList]?
    public var syncMsg: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["syncList"] = self.syncList?.encodeToJSON()
        nillableDictionary["syncMsg"] = self.syncMsg

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

