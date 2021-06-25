
import UIKit


struct Hole {
    let location: CGPoint
    let number: Int
}

enum CourseType {
    case holes9
    case holes18
    var image: UIImage? {
        switch self {
        case .holes9:
            return UIImage(named: "Map")
        case .holes18:
            return UIImage(named: "Skataas18")
        }
    }
    var holes: [Hole] {
        switch self {
        case .holes9:
            return Course.holes9
        case .holes18:
            return Course.holes18
        }
    }
    var backgroundColour: UIColor {
        switch self {
        case .holes9:
            return UIColor(red: 134/255, green: 192/255, blue: 159/255, alpha: 1.0)
        case .holes18:
            return UIColor(red: 64/255, green: 132/255, blue: 90/255, alpha: 1.0)
        }
    }
}

struct Course {
    // Original unscaled coordinates here.
    static let holes9 = [
        Hole(location: CGPoint(x: 346, y: 79), number: 1),
        Hole(location: CGPoint(x: 438, y: 45), number: 2),
        Hole(location: CGPoint(x: 374, y: 265), number: 3),
        Hole(location: CGPoint(x: 349, y: 628), number: 4),
        Hole(location: CGPoint(x: 280, y: 719), number: 5),
        Hole(location: CGPoint(x: 143, y: 757), number: 6),
        Hole(location: CGPoint(x: 250, y: 468), number: 7),
        Hole(location: CGPoint(x: 226, y: 363), number: 8),
        Hole(location: CGPoint(x: 309, y: 322), number: 9),
    ]
    static let holes18 = [
        Hole(location: CGPoint(x: 1130, y: 1800), number: 1),
        Hole(location: CGPoint(x: 750, y: 1480), number: 2),
        Hole(location: CGPoint(x: 425, y: 1450), number: 3),
        Hole(location: CGPoint(x: 550, y: 1040), number: 4),
        Hole(location: CGPoint(x: 280, y: 1000), number: 5),
        Hole(location: CGPoint(x: 990, y: 940), number: 6),
        Hole(location: CGPoint(x: 1395, y: 850), number: 7),
        Hole(location: CGPoint(x: 2020, y: 900), number: 8),
        Hole(location: CGPoint(x: 2300, y: 810), number: 9),
        Hole(location: CGPoint(x: 2540, y: 990), number: 10),
        Hole(location: CGPoint(x: 2410, y: 1490), number: 11),
        Hole(location: CGPoint(x: 2600, y: 2150), number: 12),
        Hole(location: CGPoint(x: 3040, y: 2830), number: 13),
        Hole(location: CGPoint(x: 3170, y: 3100), number: 14),
        Hole(location: CGPoint(x: 2760, y: 3260), number: 15),
        Hole(location: CGPoint(x: 1840, y: 3140), number: 16),
        Hole(location: CGPoint(x: 1370, y: 3350), number: 17),
        Hole(location: CGPoint(x: 1200, y: 3730), number: 18),
    ]
}
