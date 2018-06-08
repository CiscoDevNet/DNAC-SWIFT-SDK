//
// SiteResultResponseSites.swift
//

//

import Foundation


open class SiteResultResponseSites: JSONEncodable {

    public var displayName: String?
    public var groupNameHierarchy: String?
    public var id: String?
    public var latitude: String?
    public var locationAddress: String?
    public var locationCountry: String?
    public var locationType: String?
    public var longitude: String?
    public var name: String?
    public var parentId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["displayName"] = self.displayName
        nillableDictionary["groupNameHierarchy"] = self.groupNameHierarchy
        nillableDictionary["id"] = self.id
        nillableDictionary["latitude"] = self.latitude
        nillableDictionary["locationAddress"] = self.locationAddress
        nillableDictionary["locationCountry"] = self.locationCountry
        nillableDictionary["locationType"] = self.locationType
        nillableDictionary["longitude"] = self.longitude
        nillableDictionary["name"] = self.name
        nillableDictionary["parentId"] = self.parentId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

