//
// ClientDetailResponseResponse.swift
//

//

import Foundation


open class ClientDetailResponseResponse: JSONEncodable {

    public var detail: ClientDetailResponseResponseDetail?
    public var connectionInfo: ClientDetailResponseResponseConnectionInfo?
    public var topology: ClientDetailResponseResponseTopology?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["detail"] = self.detail?.encodeToJSON()
        nillableDictionary["connectionInfo"] = self.connectionInfo?.encodeToJSON()
        nillableDictionary["topology"] = self.topology?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

