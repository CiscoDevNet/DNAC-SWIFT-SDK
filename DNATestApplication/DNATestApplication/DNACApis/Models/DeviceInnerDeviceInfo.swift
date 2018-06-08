//
// DeviceInnerDeviceInfo.swift
//

//

import Foundation


open class DeviceInnerDeviceInfo: JSONEncodable {

    public enum AgentType: String { 
        case posix = "POSIX"
        case ios = "IOS"
    }
    public enum CmState: String { 
        case notContacted = "NotContacted"
        case contacted = "Contacted"
        case disconnected = "Disconnected"
        case securingConnection = "SecuringConnection"
        case securedConnection = "SecuredConnection"
        case authenticated = "Authenticated"
        case errorSecuringConnection = "ErrorSecuringConnection"
        case errorAuthenticating = "ErrorAuthenticating"
    }
    public enum OnbState: String { 
        case notContacted = "NotContacted"
        case connecting = "Connecting"
        case errorSecuringConnection = "ErrorSecuringConnection"
        case errorAuthenticating = "ErrorAuthenticating"
        case initializing = "Initializing"
        case initialized = "Initialized"
        case errorInitializing = "ErrorInitializing"
        case errorSudiAuthorizing = "ErrorSudiAuthorizing"
        case executingWorkflow = "ExecutingWorkflow"
        case executedWorkflow = "ExecutedWorkflow"
        case errorExecutingWorkflow = "ErrorExecutingWorkflow"
        case executingReset = "ExecutingReset"
        case errorExecutingReset = "ErrorExecutingReset"
        case provisioned = "Provisioned"
    }
    public enum State: String { 
        case unclaimed = "Unclaimed"
        case planned = "Planned"
        case onboarding = "Onboarding"
        case provisioned = "Provisioned"
        case error = "Error"
        case deleted = "Deleted"
    }
    public var aaaCredentials: DeviceInnerDeviceInfoAaaCredentials?
    public var addedOn: Int32?
    public var addnMacAddrs: [String]?
    public var agentType: AgentType?
    public var authStatus: String?
    public var authenticatedSudiSerialNo: String?
    public var capabilitiesSupported: [String]?
    public var cmState: CmState?
    public var description: String?
    public var deviceSudiSerialNos: [String]?
    public var deviceType: String?
    public var featuresSupported: [String]?
    public var fileSystemList: [DeviceInnerDeviceInfoFileSystemList]?
    public var firstContact: Int32?
    public var hostname: String?
    public var httpHeaders: [ResetRequestConfigParameters]?
    public var imageFile: String?
    public var imageVersion: String?
    public var ipInterfaces: [DeviceInnerDeviceInfoIpInterfaces]?
    public var lastContact: Int32?
    public var lastSyncTime: Int32?
    public var lastUpdateOn: Int32?
    public var location: DeviceInnerDeviceInfoLocation?
    public var macAddress: String?
    public var mode: String?
    public var name: String?
    public var neighborLinks: [DeviceInnerDeviceInfoNeighborLinks]?
    public var onbState: OnbState?
    public var pid: String?
    public var pnpProfileList: [DeviceInnerDeviceInfoPnpProfileList]?
    public var preWorkflowCliOuputs: [DeviceInnerDeviceInfoPreWorkflowCliOuputs]?
    public var projectId: String?
    public var projectName: String?
    public var reloadRequested: Bool?
    public var serialNumber: String?
    public var smartAccountId: String?
    public var source: String?
    public var stack: Bool?
    public var stackInfo: DeviceInnerDeviceInfoStackInfo?
    public var state: State?
    public var sudiRequired: Bool?
    public var tags: Any?
    public var userSudiSerialNos: [String]?
    public var virtualAccountId: String?
    public var workflowId: String?
    public var workflowName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["aaaCredentials"] = self.aaaCredentials?.encodeToJSON()
        nillableDictionary["addedOn"] = self.addedOn?.encodeToJSON()
        nillableDictionary["addnMacAddrs"] = self.addnMacAddrs?.encodeToJSON()
        nillableDictionary["agentType"] = self.agentType?.rawValue
        nillableDictionary["authStatus"] = self.authStatus
        nillableDictionary["authenticatedSudiSerialNo"] = self.authenticatedSudiSerialNo
        nillableDictionary["capabilitiesSupported"] = self.capabilitiesSupported?.encodeToJSON()
        nillableDictionary["cmState"] = self.cmState?.rawValue
        nillableDictionary["description"] = self.description
        nillableDictionary["deviceSudiSerialNos"] = self.deviceSudiSerialNos?.encodeToJSON()
        nillableDictionary["deviceType"] = self.deviceType
        nillableDictionary["featuresSupported"] = self.featuresSupported?.encodeToJSON()
        nillableDictionary["fileSystemList"] = self.fileSystemList?.encodeToJSON()
        nillableDictionary["firstContact"] = self.firstContact?.encodeToJSON()
        nillableDictionary["hostname"] = self.hostname
        nillableDictionary["httpHeaders"] = self.httpHeaders?.encodeToJSON()
        nillableDictionary["imageFile"] = self.imageFile
        nillableDictionary["imageVersion"] = self.imageVersion
        nillableDictionary["ipInterfaces"] = self.ipInterfaces?.encodeToJSON()
        nillableDictionary["lastContact"] = self.lastContact?.encodeToJSON()
        nillableDictionary["lastSyncTime"] = self.lastSyncTime?.encodeToJSON()
        nillableDictionary["lastUpdateOn"] = self.lastUpdateOn?.encodeToJSON()
        nillableDictionary["location"] = self.location?.encodeToJSON()
        nillableDictionary["macAddress"] = self.macAddress
        nillableDictionary["mode"] = self.mode
        nillableDictionary["name"] = self.name
        nillableDictionary["neighborLinks"] = self.neighborLinks?.encodeToJSON()
        nillableDictionary["onbState"] = self.onbState?.rawValue
        nillableDictionary["pid"] = self.pid
        nillableDictionary["pnpProfileList"] = self.pnpProfileList?.encodeToJSON()
        nillableDictionary["preWorkflowCliOuputs"] = self.preWorkflowCliOuputs?.encodeToJSON()
        nillableDictionary["projectId"] = self.projectId
        nillableDictionary["projectName"] = self.projectName
        nillableDictionary["reloadRequested"] = self.reloadRequested
        nillableDictionary["serialNumber"] = self.serialNumber
        nillableDictionary["smartAccountId"] = self.smartAccountId
        nillableDictionary["source"] = self.source
        nillableDictionary["stack"] = self.stack
        nillableDictionary["stackInfo"] = self.stackInfo?.encodeToJSON()
        nillableDictionary["state"] = self.state?.rawValue
        nillableDictionary["sudiRequired"] = self.sudiRequired
        nillableDictionary["tags"] = self.tags
        nillableDictionary["userSudiSerialNos"] = self.userSudiSerialNos?.encodeToJSON()
        nillableDictionary["virtualAccountId"] = self.virtualAccountId
        nillableDictionary["workflowId"] = self.workflowId
        nillableDictionary["workflowName"] = self.workflowName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

