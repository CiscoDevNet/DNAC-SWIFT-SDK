//
// ImageInfoListResponseResponse.swift
//

//

import Foundation


open class ImageInfoListResponseResponse: JSONEncodable {

    public enum ImportSourceType: String { 
        case device = "DEVICE"
        case remoteurl = "REMOTEURL"
        case cco = "CCO"
        case filesystem = "FILESYSTEM"
    }
    public var applicableDevicesForImage: [ImageInfoListResponseApplicableDevicesForImage]?
    public var applicationType: String?
    public var createdTime: String?
    public var extendedAttributes: Any?
    public var family: String?
    public var feature: String?
    public var fileServiceId: String?
    public var fileSize: String?
    public var imageIntegrityStatus: String?
    public var imageName: String?
    public var imageSeries: [String]?
    public var imageSource: String?
    public var imageType: String?
    public var imageUuid: String?
    public var importSourceType: ImportSourceType?
    public var isTaggedGolden: Bool?
    public var md5Checksum: String?
    public var name: String?
    public var profileInfo: [ImageInfoListResponseProfileInfo]?
    public var shaCheckSum: String?
    public var vendor: String?
    public var version: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["applicableDevicesForImage"] = self.applicableDevicesForImage?.encodeToJSON()
        nillableDictionary["applicationType"] = self.applicationType
        nillableDictionary["createdTime"] = self.createdTime
        nillableDictionary["extendedAttributes"] = self.extendedAttributes
        nillableDictionary["family"] = self.family
        nillableDictionary["feature"] = self.feature
        nillableDictionary["fileServiceId"] = self.fileServiceId
        nillableDictionary["fileSize"] = self.fileSize
        nillableDictionary["imageIntegrityStatus"] = self.imageIntegrityStatus
        nillableDictionary["imageName"] = self.imageName
        nillableDictionary["imageSeries"] = self.imageSeries?.encodeToJSON()
        nillableDictionary["imageSource"] = self.imageSource
        nillableDictionary["imageType"] = self.imageType
        nillableDictionary["imageUuid"] = self.imageUuid
        nillableDictionary["importSourceType"] = self.importSourceType?.rawValue
        nillableDictionary["isTaggedGolden"] = self.isTaggedGolden
        nillableDictionary["md5Checksum"] = self.md5Checksum
        nillableDictionary["name"] = self.name
        nillableDictionary["profileInfo"] = self.profileInfo?.encodeToJSON()
        nillableDictionary["shaCheckSum"] = self.shaCheckSum
        nillableDictionary["vendor"] = self.vendor
        nillableDictionary["version"] = self.version

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

