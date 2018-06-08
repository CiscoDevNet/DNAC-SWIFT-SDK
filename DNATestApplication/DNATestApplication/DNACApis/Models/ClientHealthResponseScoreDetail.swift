//
// ClientHealthResponseScoreDetail.swift
//

//

import Foundation


open class ClientHealthResponseScoreDetail: JSONEncodable {

    public var scoreCategory: ClientHealthResponseScoreCategory?
    public var scoreValue: String?
    public var clientCount: String?
    public var clientUniqueCount: String?
    public var starttime: String?
    public var endtime: String?
    public var scoreList: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["scoreCategory"] = self.scoreCategory?.encodeToJSON()
        nillableDictionary["scoreValue"] = self.scoreValue
        nillableDictionary["clientCount"] = self.clientCount
        nillableDictionary["clientUniqueCount"] = self.clientUniqueCount
        nillableDictionary["starttime"] = self.starttime
        nillableDictionary["endtime"] = self.endtime
        nillableDictionary["scoreList"] = self.scoreList?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

