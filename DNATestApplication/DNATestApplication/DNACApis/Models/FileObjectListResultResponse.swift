//
// FileObjectListResultResponse.swift
//

//

import Foundation


open class FileObjectListResultResponse: JSONEncodable {

    public var attributeInfo: Any?
    public var downloadPath: String?
    public var encrypted: Bool?
    public var fileFormat: String?
    public var fileSize: String?
    public var id: String?
    public var md5Checksum: String?
    public var name: String?
    public var nameSpace: String?
    public var sftpServerList: [Any]?
    public var sha1Checksum: String?
    public var taskId: Any?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["downloadPath"] = self.downloadPath
        nillableDictionary["encrypted"] = self.encrypted
        nillableDictionary["fileFormat"] = self.fileFormat
        nillableDictionary["fileSize"] = self.fileSize
        nillableDictionary["id"] = self.id
        nillableDictionary["md5Checksum"] = self.md5Checksum
        nillableDictionary["name"] = self.name
        nillableDictionary["nameSpace"] = self.nameSpace
        nillableDictionary["sftpServerList"] = self.sftpServerList?.encodeToJSON()
        nillableDictionary["sha1Checksum"] = self.sha1Checksum
        nillableDictionary["taskId"] = self.taskId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

