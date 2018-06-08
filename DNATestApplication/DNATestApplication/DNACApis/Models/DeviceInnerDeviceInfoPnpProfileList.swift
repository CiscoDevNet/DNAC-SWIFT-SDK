//
// DeviceInnerDeviceInfoPnpProfileList.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoPnpProfileList: JSONEncodable {

    public var createdBy: String?
    public var discoveryCreated: Bool?
    public var primaryEndpoint: DeviceInnerDeviceInfoPrimaryEndpoint?
    public var profileName: String?
    public var secondaryEndpoint: DeviceInnerDeviceInfoPrimaryEndpoint?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["createdBy"] = self.createdBy
        nillableDictionary["discoveryCreated"] = self.discoveryCreated
        nillableDictionary["primaryEndpoint"] = self.primaryEndpoint?.encodeToJSON()
        nillableDictionary["profileName"] = self.profileName
        nillableDictionary["secondaryEndpoint"] = self.secondaryEndpoint?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

