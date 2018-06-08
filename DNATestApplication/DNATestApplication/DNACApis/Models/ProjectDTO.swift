//
// ProjectDTO.swift
//

//

import Foundation


open class ProjectDTO: JSONEncodable {

    public var createTime: Int32?
    public var description: String?
    public var id: String?
    public var lastUpdateTime: Int32?
    public var name: String?
    public var tags: [String]?
    public var templates: Any?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["createTime"] = self.createTime?.encodeToJSON()
        nillableDictionary["description"] = self.description
        nillableDictionary["id"] = self.id
        nillableDictionary["lastUpdateTime"] = self.lastUpdateTime?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["tags"] = self.tags?.encodeToJSON()
        nillableDictionary["templates"] = self.templates

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

