//
// DeviceInner.swift
//

//

import Foundation


open class DeviceInner: JSONEncodable {

    public var id: String?
    public var deviceInfo: DeviceInnerDeviceInfo?
    public var runSummaryList: [DeviceInnerRunSummaryList]?
    public var systemResetWorkflow: DeviceInnerSystemResetWorkflow?
    public var systemWorkflow: DeviceInnerSystemResetWorkflow?
    public var tenantId: String?
    public var version: Int32?
    public var workflow: DeviceInnerSystemResetWorkflow?
    public var workflowParameters: DeviceInnerWorkflowParameters?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["_id"] = self.id
        nillableDictionary["deviceInfo"] = self.deviceInfo?.encodeToJSON()
        nillableDictionary["runSummaryList"] = self.runSummaryList?.encodeToJSON()
        nillableDictionary["systemResetWorkflow"] = self.systemResetWorkflow?.encodeToJSON()
        nillableDictionary["systemWorkflow"] = self.systemWorkflow?.encodeToJSON()
        nillableDictionary["tenantId"] = self.tenantId
        nillableDictionary["version"] = self.version?.encodeToJSON()
        nillableDictionary["workflow"] = self.workflow?.encodeToJSON()
        nillableDictionary["workflowParameters"] = self.workflowParameters?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

