//
// TemplateDeploymentStatusDTO.swift
//

//

import Foundation


open class TemplateDeploymentStatusDTO: JSONEncodable {

    public var deploymentId: String?
    public var deploymentName: String?
    public var devices: [TemplateDeploymentStatusDTODevices]?
    public var duration: String?
    public var endTime: String?
    public var projectName: String?
    public var startTime: String?
    public var status: String?
    public var templateName: String?
    public var templateVersion: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["deploymentId"] = self.deploymentId
        nillableDictionary["deploymentName"] = self.deploymentName
        nillableDictionary["devices"] = self.devices?.encodeToJSON()
        nillableDictionary["duration"] = self.duration
        nillableDictionary["endTime"] = self.endTime
        nillableDictionary["projectName"] = self.projectName
        nillableDictionary["startTime"] = self.startTime
        nillableDictionary["status"] = self.status
        nillableDictionary["templateName"] = self.templateName
        nillableDictionary["templateVersion"] = self.templateVersion

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

