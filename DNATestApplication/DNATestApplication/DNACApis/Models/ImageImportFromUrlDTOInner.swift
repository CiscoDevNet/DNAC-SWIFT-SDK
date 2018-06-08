//
// ImageImportFromUrlDTOInner.swift
//

//

import Foundation


open class ImageImportFromUrlDTOInner: JSONEncodable {

    public var applicationType: String?
    public var imageFamily: String?
    public var sourceURL: String?
    public var thirdParty: Bool?
    public var vendor: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["applicationType"] = self.applicationType
        nillableDictionary["imageFamily"] = self.imageFamily
        nillableDictionary["sourceURL"] = self.sourceURL
        nillableDictionary["thirdParty"] = self.thirdParty
        nillableDictionary["vendor"] = self.vendor

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

