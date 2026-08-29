import SwiftData
import Foundation

@Model
final class SavedMeasurement {
    var name: String
    var distanceInMeters: Double
    var date: Date
    var iconName: String

    init(
        name: String,
        distanceInMeters: Double,
        date: Date = .now,
        iconName: String = "ruler"
    ) {
        self.name = name
        self.distanceInMeters = distanceInMeters
        self.date = date
        self.iconName = iconName
    }

    var formattedDistance: String {
        let cm = distanceInMeters * 100
        return cm < 100 ? String(format: "%.1f cm", cm) : String(format: "%.2f m", distanceInMeters)
    }
}

