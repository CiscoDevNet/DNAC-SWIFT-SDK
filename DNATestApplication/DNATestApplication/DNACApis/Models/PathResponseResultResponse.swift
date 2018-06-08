//
// PathResponseResultResponse.swift
//

//

import Foundation


open class PathResponseResultResponse: JSONEncodable {

    public var detailedStatus: PathResponseResultResponseDetailedStatus?
    public var lastUpdate: String?
    public var networkElements: [PathResponseResultResponseNetworkElements]?
    public var networkElementsInfo: [PathResponseResultResponseNetworkElementsInfo]?
    public var properties: [String]?
    public var request: FlowAnalysisListOutputResponse?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["detailedStatus"] = self.detailedStatus?.encodeToJSON()
        nillableDictionary["lastUpdate"] = self.lastUpdate
        nillableDictionary["networkElements"] = self.networkElements?.encodeToJSON()
        nillableDictionary["networkElementsInfo"] = self.networkElementsInfo?.encodeToJSON()
        nillableDictionary["properties"] = self.properties?.encodeToJSON()
        nillableDictionary["request"] = self.request?.encodeToJSON()

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

