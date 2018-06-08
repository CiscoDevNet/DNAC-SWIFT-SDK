//
// CommandRunnerDTO.swift
//

//

import Foundation


open class CommandRunnerDTO: JSONEncodable {

    public var commands: [String]?
    public var description: String?
    public var deviceUuids: [String]?
    public var name: String?
    public var timeout: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["commands"] = self.commands?.encodeToJSON()
        nillableDictionary["description"] = self.description
        nillableDictionary["deviceUuids"] = self.deviceUuids?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["timeout"] = self.timeout?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

