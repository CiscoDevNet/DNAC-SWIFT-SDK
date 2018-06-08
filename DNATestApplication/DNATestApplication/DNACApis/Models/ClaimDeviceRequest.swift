//
// ClaimDeviceRequest.swift
//

//

import Foundation


open class ClaimDeviceRequest: JSONEncodable {

    public var configFileUrl: String?
    public var configId: String?
    public var deviceClaimList: [ResetRequestDeviceResetList]?
    public var fileServiceId: String?
    public var imageId: String?
    public var imageUrl: String?
    public var projectId: String?
    public var workflowId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["configFileUrl"] = self.configFileUrl
        nillableDictionary["configId"] = self.configId
        nillableDictionary["deviceClaimList"] = self.deviceClaimList?.encodeToJSON()
        nillableDictionary["fileServiceId"] = self.fileServiceId
        nillableDictionary["imageId"] = self.imageId
        nillableDictionary["imageUrl"] = self.imageUrl
        nillableDictionary["projectId"] = self.projectId
        nillableDictionary["workflowId"] = self.workflowId

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

