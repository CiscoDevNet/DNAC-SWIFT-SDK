// Extensions.swift
//

//

import Foundation
import Alamofire

extension Bool: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Float: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Int: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Int32: JSONEncodable {
    func encodeToJSON() -> Any { return NSNumber(value: self as Int32) }
}

extension Int64: JSONEncodable {
    func encodeToJSON() -> Any { return NSNumber(value: self as Int64) }
}

extension Double: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension String: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

private func encodeIfPossible<T>(_ object: T) -> Any {
    if let encodableObject = object as? JSONEncodable {
        return encodableObject.encodeToJSON()
    } else {
        return object as Any
    }
}

extension Array: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.map(encodeIfPossible)
    }
}

extension Dictionary: JSONEncodable {
    func encodeToJSON() -> Any {
        var dictionary = [AnyHashable: Any]()
        for (key, value) in self {
            dictionary[key] = encodeIfPossible(value)
        }
        return dictionary as Any
    }
}

extension Data: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.base64EncodedString(options: Data.Base64EncodingOptions())
    }
}

private let dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = Configuration.dateFormat
    fmt.locale = Locale(identifier: "en_US_POSIX")
    return fmt
}()

extension Date: JSONEncodable {
    func encodeToJSON() -> Any {
        return dateFormatter.string(from: self) as Any
    }
}

extension UUID: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.uuidString
    }
}

/// Represents an ISO-8601 full-date (RFC-3339).
/// ex: 12-31-1999
/// https://xml2rfc.tools.ietf.org/public/rfc/html/rfc3339.html#anchor14
public final class ISOFullDate: CustomStringConvertible {

    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    /**
     Converts a Date to an ISOFullDate. Only interested in the year, month, day components.

     - parameter date: The date to convert.

     - returns: An ISOFullDate constructed from the year, month, day of the date.
     */
    public static func from(date: Date) -> ISOFullDate? {
        let calendar = Calendar(identifier: .gregorian)

        let components = calendar.dateComponents(
            [
                .year,
                .month,
                .day,
            ],
            from: date
        )

        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
        else {
            return nil
        }

        return ISOFullDate(
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Converts a ISO-8601 full-date string to an ISOFullDate.

     - parameter string: The ISO-8601 full-date format string to convert.

     - returns: An ISOFullDate constructed from the string.
     */
    public static func from(string: String) -> ISOFullDate? {
        let components = string
            .characters
            .split(separator: "-")
            .map(String.init)
            .flatMap { Int($0) }
        guard components.count == 3 else { return nil }

        return ISOFullDate(
            year: components[0],
            month: components[1],
            day: components[2]
        )
    }

    /**
     Converts the receiver to a Date, in the default time zone.

     - returns: A Date from the components of the receiver, in the default time zone.
     */
    public func toDate() -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = TimeZone.ReferenceType.default
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)
    }

    // MARK: CustomStringConvertible

    public var description: String {
        return "\(year)-\(month)-\(day)"
    }

}

extension ISOFullDate: JSONEncodable {
    public func encodeToJSON() -> Any {
        return "\(year)-\(month)-\(day)"
    }
}


