//
// FunctionalCapabilityListResultFunctionalCapability.swift
//

//

import Foundation


open class FunctionalCapabilityListResultFunctionalCapability: JSONEncodable {

    public enum FunctionOpState: String { 
        case unknown = "UNKNOWN"
        case notApplicable = "NOT_APPLICABLE"
        case disabled = "DISABLED"
        case enabled = "ENABLED"
    }
    public var attributeInfo: Any?
    public var functionDetails: [FunctionalCapabilityListResultFunctionDetails]?
    public var functionName: String?
    public var functionOpState: FunctionOpState?
    public var id: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["attributeInfo"] = self.attributeInfo
        nillableDictionary["functionDetails"] = self.functionDetails?.encodeToJSON()
        nillableDictionary["functionName"] = self.functionName
        nillableDictionary["functionOpState"] = self.functionOpState?.rawValue
        nillableDictionary["id"] = self.id

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

