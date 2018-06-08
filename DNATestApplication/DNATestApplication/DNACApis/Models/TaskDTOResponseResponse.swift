//
// TaskDTOResponseResponse.swift
//

//

import Foundation


open class TaskDTOResponseResponse: JSONEncodable {

    public var additionalStatusURL: String?
    public var data: String?
    public var endTime: String?
    public var errorCode: String?
    public var errorKey: String?
    public var failureReason: String?
    public var id: String?
    public var instanceTenantId: String?
    public var isError: Bool?
    public var lastUpdate: String?
    public var operationIdList: Any?
    public var parentId: String?
    public var progress: String?
    public var rootId: String?
    public var serviceType: String?
    public var startTime: String?
    public var username: String?
    public var version: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["additionalStatusURL"] = self.additionalStatusURL
        nillableDictionary["data"] = self.data
        nillableDictionary["endTime"] = self.endTime
        nillableDictionary["errorCode"] = self.errorCode
        nillableDictionary["errorKey"] = self.errorKey
        nillableDictionary["failureReason"] = self.failureReason
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["isError"] = self.isError
        nillableDictionary["lastUpdate"] = self.lastUpdate
        nillableDictionary["operationIdList"] = self.operationIdList
        nillableDictionary["parentId"] = self.parentId
        nillableDictionary["progress"] = self.progress
        nillableDictionary["rootId"] = self.rootId
        nillableDictionary["serviceType"] = self.serviceType
        nillableDictionary["startTime"] = self.startTime
        nillableDictionary["username"] = self.username
        nillableDictionary["version"] = self.version?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

