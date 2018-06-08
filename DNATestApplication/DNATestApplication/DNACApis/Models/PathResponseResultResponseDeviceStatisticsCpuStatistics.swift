//
// PathResponseResultResponseDeviceStatisticsCpuStatistics.swift
//

//

import Foundation


open class PathResponseResultResponseDeviceStatisticsCpuStatistics: JSONEncodable {

    public var fiveMinUsageInPercentage: Double?
    public var fiveSecsUsageInPercentage: Double?
    public var oneMinUsageInPercentage: Double?
    public var refreshedAt: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["fiveMinUsageInPercentage"] = self.fiveMinUsageInPercentage
        nillableDictionary["fiveSecsUsageInPercentage"] = self.fiveSecsUsageInPercentage
        nillableDictionary["oneMinUsageInPercentage"] = self.oneMinUsageInPercentage
        nillableDictionary["refreshedAt"] = self.refreshedAt?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

