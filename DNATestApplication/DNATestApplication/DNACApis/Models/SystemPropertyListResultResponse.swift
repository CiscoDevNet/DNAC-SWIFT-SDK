//
// SystemPropertyListResultResponse.swift
//

//

import Foundation


open class SystemPropertyListResultResponse: JSONEncodable {

    public var id: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var intValue: Int32?
    public var systemPropertyName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["intValue"] = self.intValue?.encodeToJSON()
        nillableDictionary["systemPropertyName"] = self.systemPropertyName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

