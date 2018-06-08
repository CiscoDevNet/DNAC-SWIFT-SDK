//
// ActivateDTOInner.swift
//

//

import Foundation


open class ActivateDTOInner: JSONEncodable {

    public var activateLowerImageVersion: Bool?
    public var deviceUpgradeMode: String?
    public var deviceUuid: String?
    public var distributeIfNeeded: Bool?
    public var imageUuidList: [String]?
    public var smuImageUuidList: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["activateLowerImageVersion"] = self.activateLowerImageVersion
        nillableDictionary["deviceUpgradeMode"] = self.deviceUpgradeMode
        nillableDictionary["deviceUuid"] = self.deviceUuid
        nillableDictionary["distributeIfNeeded"] = self.distributeIfNeeded
        nillableDictionary["imageUuidList"] = self.imageUuidList?.encodeToJSON()
        nillableDictionary["smuImageUuidList"] = self.smuImageUuidList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

