//
// PathResponseResultResponseDeviceStatistics.swift
//

//

import Foundation


open class PathResponseResultResponseDeviceStatistics: JSONEncodable {

    public var cpuStatistics: PathResponseResultResponseDeviceStatisticsCpuStatistics?
    public var memoryStatistics: PathResponseResultResponseDeviceStatisticsMemoryStatistics?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["cpuStatistics"] = self.cpuStatistics?.encodeToJSON()
        nillableDictionary["memoryStatistics"] = self.memoryStatistics?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

