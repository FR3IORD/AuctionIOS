// MARK: - 🎨 Extensions & Utilities

import UIKit

extension UIColor {
    static let primaryBlue = UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 1.0)
    static let secondaryPurple = UIColor(red: 139/255, green: 92/255, blue: 246/255, alpha: 1.0)
    static let successGreen = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
    static let dangerRed = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)
}

extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₾"
        return formatter.string(from: NSNumber(value: self)) ?? "₾0.00"
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    
    func timeAgo() -> String {
        guard let date = self.toDate() else { return "Unknown" }
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 { return "just now" }
        if interval < 3600 { return "\(Int(interval/60))m ago" }
        if interval < 86400 { return "\(Int(interval/3600))h ago" }
        return "\(Int(interval/86400))d ago"
    }
}
