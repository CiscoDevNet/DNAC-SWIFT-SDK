//
// PathResponseResultResponseFlexConnect.swift
//

//

import Foundation


open class PathResponseResultResponseFlexConnect: JSONEncodable {

    public enum Authentication: String { 
        case local = "LOCAL"
        case central = "CENTRAL"
    }
    public enum DataSwitching: String { 
        case local = "LOCAL"
        case central = "CENTRAL"
    }
    public var authentication: Authentication?
    public var dataSwitching: DataSwitching?
    public var egressAclAnalysis: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis?
    public var ingressAclAnalysis: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis?
    public var wirelessLanControllerId: String?
    public var wirelessLanControllerName: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["authentication"] = self.authentication?.rawValue
        nillableDictionary["dataSwitching"] = self.dataSwitching?.rawValue
        nillableDictionary["egressAclAnalysis"] = self.egressAclAnalysis?.encodeToJSON()
        nillableDictionary["ingressAclAnalysis"] = self.ingressAclAnalysis?.encodeToJSON()
        nillableDictionary["wirelessLanControllerId"] = self.wirelessLanControllerId
        nillableDictionary["wirelessLanControllerName"] = self.wirelessLanControllerName

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

