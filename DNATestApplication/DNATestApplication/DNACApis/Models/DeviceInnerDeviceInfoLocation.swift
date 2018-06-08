//
// DeviceInnerDeviceInfoLocation.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoLocation: JSONEncodable {

    public var address: String?
    public var altitude: String?
    public var latitude: String?
    public var longitude: String?
    public var siteId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["address"] = self.address
        nillableDictionary["altitude"] = self.altitude
        nillableDictionary["latitude"] = self.latitude
        nillableDictionary["longitude"] = self.longitude
        nillableDictionary["siteId"] = self.siteId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

