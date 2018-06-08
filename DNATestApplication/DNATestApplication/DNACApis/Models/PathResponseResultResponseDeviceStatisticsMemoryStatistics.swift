//
// PathResponseResultResponseDeviceStatisticsMemoryStatistics.swift
//

//

import Foundation


open class PathResponseResultResponseDeviceStatisticsMemoryStatistics: JSONEncodable {

    public var memoryUsage: Int32?
    public var refreshedAt: Int32?
    public var totalMemory: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["memoryUsage"] = self.memoryUsage?.encodeToJSON()
        nillableDictionary["refreshedAt"] = self.refreshedAt?.encodeToJSON()
        nillableDictionary["totalMemory"] = self.totalMemory?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

