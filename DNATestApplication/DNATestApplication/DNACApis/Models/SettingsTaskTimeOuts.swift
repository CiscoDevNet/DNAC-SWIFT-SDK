//
// SettingsTaskTimeOuts.swift
//

//

import Foundation


open class SettingsTaskTimeOuts: JSONEncodable {

    public var configTimeOut: Int32?
    public var generalTimeOut: Int32?
    public var imageDownloadTimeOut: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["configTimeOut"] = self.configTimeOut?.encodeToJSON()
        nillableDictionary["generalTimeOut"] = self.generalTimeOut?.encodeToJSON()
        nillableDictionary["imageDownloadTimeOut"] = self.imageDownloadTimeOut?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

