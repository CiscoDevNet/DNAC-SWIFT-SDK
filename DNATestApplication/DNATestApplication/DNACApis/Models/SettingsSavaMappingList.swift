//
// SettingsSavaMappingList.swift
//

//

import Foundation


open class SettingsSavaMappingList: JSONEncodable {

    public enum SyncStatus: String { 
        case notSynced = "NOT_SYNCED"
        case syncing = "SYNCING"
        case success = "SUCCESS"
        case failure = "FAILURE"
    }
    public var autoSyncPeriod: Int32?
    public var ccoUser: String?
    public var expiry: Int32?
    public var lastSync: Int32?
    public var profile: SAVAMappingProfile?
    public var smartAccountId: String?
    public var syncResult: SAVAMappingSyncResult?
    public var syncResultStr: String?
    public var syncStartTime: Int32?
    public var syncStatus: SyncStatus?
    public var tenantId: String?
    public var token: String?
    public var virtualAccountId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["autoSyncPeriod"] = self.autoSyncPeriod?.encodeToJSON()
        nillableDictionary["ccoUser"] = self.ccoUser
        nillableDictionary["expiry"] = self.expiry?.encodeToJSON()
        nillableDictionary["lastSync"] = self.lastSync?.encodeToJSON()
        nillableDictionary["profile"] = self.profile?.encodeToJSON()
        nillableDictionary["smartAccountId"] = self.smartAccountId
        nillableDictionary["syncResult"] = self.syncResult?.encodeToJSON()
        nillableDictionary["syncResultStr"] = self.syncResultStr
        nillableDictionary["syncStartTime"] = self.syncStartTime?.encodeToJSON()
        nillableDictionary["syncStatus"] = self.syncStatus?.rawValue
        nillableDictionary["tenantId"] = self.tenantId
        nillableDictionary["token"] = self.token
        nillableDictionary["virtualAccountId"] = self.virtualAccountId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

