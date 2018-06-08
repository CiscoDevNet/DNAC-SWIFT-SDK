//
// DistributeDTOInner.swift
//

//

import Foundation


open class DistributeDTOInner: JSONEncodable {

    public var deviceUuid: String?
    public var imageUuid: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deviceUuid"] = self.deviceUuid
        nillableDictionary["imageUuid"] = self.imageUuid

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

