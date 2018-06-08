//
// SNMPvCredentialDTOInner.swift
//

//

import Foundation


open class SNMPvCredentialDTOInner: JSONEncodable {

    public enum AuthType: String { 
        case sha = "SHA"
        case md5 = "MD5"
    }
    public enum CredentialType: String { 
        case global = "GLOBAL"
        case app = "APP"
    }
    public enum PrivacyType: String { 
        case des = "DES"
        case aes128 = "AES128"
    }
    public enum SnmpMode: String { 
        case authpriv = "AUTHPRIV"
        case authnopriv = "AUTHNOPRIV"
        case noauthnopriv = "NOAUTHNOPRIV"
    }
    public var authPassword: String?
    public var authType: AuthType?
    public var comments: String?
    public var credentialType: CredentialType?
    public var description: String?
    public var id: String?
    public var instanceTenantId: String?
    public var instanceUuid: String?
    public var privacyPassword: String?
    public var privacyType: PrivacyType?
    public var snmpMode: SnmpMode?
    public var username: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["authPassword"] = self.authPassword
        nillableDictionary["authType"] = self.authType?.rawValue
        nillableDictionary["comments"] = self.comments
        nillableDictionary["credentialType"] = self.credentialType?.rawValue
        nillableDictionary["description"] = self.description
        nillableDictionary["id"] = self.id
        nillableDictionary["instanceTenantId"] = self.instanceTenantId
        nillableDictionary["instanceUuid"] = self.instanceUuid
        nillableDictionary["privacyPassword"] = self.privacyPassword
        nillableDictionary["privacyType"] = self.privacyType?.rawValue
        nillableDictionary["snmpMode"] = self.snmpMode?.rawValue
        nillableDictionary["username"] = self.username

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

