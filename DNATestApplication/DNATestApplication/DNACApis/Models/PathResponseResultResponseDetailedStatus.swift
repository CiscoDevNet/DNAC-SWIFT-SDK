//
// PathResponseResultResponseDetailedStatus.swift
//

//

import Foundation


open class PathResponseResultResponseDetailedStatus: JSONEncodable {

    public var aclTraceCalculation: String?
    public var aclTraceCalculationFailureReason: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["aclTraceCalculation"] = self.aclTraceCalculation
        nillableDictionary["aclTraceCalculationFailureReason"] = self.aclTraceCalculationFailureReason

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

