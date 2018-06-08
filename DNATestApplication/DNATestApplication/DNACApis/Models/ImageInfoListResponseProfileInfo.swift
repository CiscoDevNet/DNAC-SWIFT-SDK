//
// ImageInfoListResponseProfileInfo.swift
//

//

import Foundation


open class ImageInfoListResponseProfileInfo: JSONEncodable {

    public var description: String?
    public var extendedAttributes: Any?
    public var memory: Int32?
    public var productType: String?
    public var profileName: String?
    public var shares: Int32?
    public var vCpu: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["description"] = self.description
        nillableDictionary["extendedAttributes"] = self.extendedAttributes
        nillableDictionary["memory"] = self.memory?.encodeToJSON()
        nillableDictionary["productType"] = self.productType
        nillableDictionary["profileName"] = self.profileName
        nillableDictionary["shares"] = self.shares?.encodeToJSON()
        nillableDictionary["vCpu"] = self.vCpu?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

