//
// NetconfCredentialDTOInner.swift
//

//

import Foundation


open class NetconfCredentialDTOInner: JSONEncodable {

    public enum CredentialType: String { 
        case global = "GLOBAL"
        case app = "APP"
    }
    public var comments: String?
    public var credentialType: CredentialType?
    public var description: String?
    public var id: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var netconfPort: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["comments"] = self.comments
        nillableDictionary["credentialType"] = self.credentialType?.rawValue
        nillableDictionary["description"] = self.description
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["netconfPort"] = self.netconfPort

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

