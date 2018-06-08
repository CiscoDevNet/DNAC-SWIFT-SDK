//
// ImageInfoListResponseApplicableDevicesForImage.swift
//

//

import Foundation


open class ImageInfoListResponseApplicableDevicesForImage: JSONEncodable {

    public var mdfId: String?
    public var productId: [String]?
    public var productName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["mdfId"] = self.mdfId
        nillableDictionary["productId"] = self.productId?.encodeToJSON()
        nillableDictionary["productName"] = self.productName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

