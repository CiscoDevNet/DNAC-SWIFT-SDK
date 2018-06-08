// APIHelper.swift
//

//

import Foundation

class APIHelper {
    static func rejectNil(_ source: [String:Any?]) -> [String:Any]? {
        var destination = [String:Any]()
        for (key, nillableValue) in source {
            if let value: Any = nillableValue {
                destination[key] = value
            }
        }

        if destination.isEmpty {
            return nil
        }
        return destination
    }

    static func rejectNilHeaders(_ source: [String:Any?]) -> [String:String] {
        var destination = [String:String]()
        for (key, nillableValue) in source {
            if let value: Any = nillableValue {
                destination[key] = "\(value)"
            }
        }
        return destination
    }

    static func convertBoolToString(_ source: [String: Any]?) -> [String:Any]? {
        guard let source = source else {
            return nil
        }
        var destination = [String:Any]()
        let theTrue = NSNumber(value: true as Bool)
        let theFalse = NSNumber(value: false as Bool)
        for (key, value) in source {
            switch value {
            case let x where x as? NSNumber === theTrue || x as? NSNumber === theFalse:
                destination[key] = "\(value as! Bool)" as Any?
            default:
                destination[key] = value
            }
        }
        return destination
    }

    static func mapValuesToQueryItems(values: [String:Any?]) -> [URLQueryItem]? {
        let returnValues = values
            .filter { $0.1 != nil }
            .map { (item: (_key: String, _value: Any?)) -> [URLQueryItem] in
                if let value = item._value as? Array<String> {
                    return value.map { (v) -> URLQueryItem in
                        URLQueryItem(
                            name: item._key,
                            value: v
                        )
                    }
                } else {
                    return [URLQueryItem(
                        name: item._key,
                        value: "\(item._value!)"
                    )]
                }
            }
            .flatMap { $0 }
 
        if returnValues.isEmpty { return nil }
        return returnValues
    }
}
