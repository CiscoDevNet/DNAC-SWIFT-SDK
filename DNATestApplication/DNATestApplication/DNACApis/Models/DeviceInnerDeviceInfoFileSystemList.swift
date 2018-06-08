//
// DeviceInnerDeviceInfoFileSystemList.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoFileSystemList: JSONEncodable {

    public var freespace: Int32?
    public var name: String?
    public var readable: Bool?
    public var size: Int32?
    public var type: String?
    public var writeable: Bool?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["freespace"] = self.freespace?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["readable"] = self.readable
        nillableDictionary["size"] = self.size?.encodeToJSON()
        nillableDictionary["type"] = self.type
        nillableDictionary["writeable"] = self.writeable

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

