//
// DeviceInnerDeviceInfoPreWorkflowCliOuputs.swift
//

//

import Foundation


open class DeviceInnerDeviceInfoPreWorkflowCliOuputs: JSONEncodable {

    public var cli: String?
    public var cliOutput: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cli"] = self.cli
        nillableDictionary["cliOutput"] = self.cliOutput

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

