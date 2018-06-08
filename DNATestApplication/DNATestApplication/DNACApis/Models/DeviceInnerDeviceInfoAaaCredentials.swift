//
// DeviceInnerDeviceInfoAaaCredentials.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoAaaCredentials: JSONEncodable {

    public var password: String?
    public var username: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["password"] = self.password
        nillableDictionary["username"] = self.username

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

