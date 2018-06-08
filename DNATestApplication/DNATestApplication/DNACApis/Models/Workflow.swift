//
// Workflow.swift
//

//

import Foundation


open class Workflow: JSONEncodable {

    public var id: String?
    public var addToInventory: Bool?
    public var addedOn: Int32?
    public var configId: String?
    public var currTaskIdx: Int32?
    public var description: String?
    public var endTime: Int32?
    public var execTime: Int32?
    public var imageId: String?
    public var lastupdateOn: Int32?
    public var name: String?
    public var startTime: Int32?
    public var state: String?
    public var tasks: [DeviceInnerSystemResetWorkflowTasks]?
    public var tenantId: String?
    public var type: String?
    public var useState: String?
    public var version: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["_id"] = self.id
        nillableDictionary["addToInventory"] = self.addToInventory
        nillableDictionary["addedOn"] = self.addedOn?.encodeToJSON()
        nillableDictionary["configId"] = self.configId
        nillableDictionary["currTaskIdx"] = self.currTaskIdx?.encodeToJSON()
        nillableDictionary["description"] = self.description
        nillableDictionary["endTime"] = self.endTime?.encodeToJSON()
        nillableDictionary["execTime"] = self.execTime?.encodeToJSON()
        nillableDictionary["imageId"] = self.imageId
        nillableDictionary["lastupdateOn"] = self.lastupdateOn?.encodeToJSON()
        nillableDictionary["name"] = self.name
        nillableDictionary["startTime"] = self.startTime?.encodeToJSON()
        nillableDictionary["state"] = self.state
        nillableDictionary["tasks"] = self.tasks?.encodeToJSON()
        nillableDictionary["tenantId"] = self.tenantId
        nillableDictionary["type"] = self.type
        nillableDictionary["useState"] = self.useState
        nillableDictionary["version"] = self.version?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

