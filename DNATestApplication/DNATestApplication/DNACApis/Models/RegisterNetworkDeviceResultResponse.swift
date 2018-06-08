//
// RegisterNetworkDeviceResultResponse.swift
//

//

import Foundation


open class RegisterNetworkDeviceResultResponse: JSONEncodable {

    public var macAddress: String?
    public var modelNumber: String?
    public var name: String?
    public var serialNumber: String?
    public var tenantId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["modelNumber"] = self.modelNumber
        nillableDictionary["name"] = self.name
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["tenantId"] = self.tenantId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

