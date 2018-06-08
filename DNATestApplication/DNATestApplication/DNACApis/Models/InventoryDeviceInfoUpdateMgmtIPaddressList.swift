//
// InventoryDeviceInfoUpdateMgmtIPaddressList.swift
//

//

import Foundation


open class InventoryDeviceInfoUpdateMgmtIPaddressList: JSONEncodable {

    public var existMgmtIpAddress: String?
    public var newMgmtIpAddress: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["existMgmtIpAddress"] = self.existMgmtIpAddress
        nillableDictionary["newMgmtIpAddress"] = self.newMgmtIpAddress

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

