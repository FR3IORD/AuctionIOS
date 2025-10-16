import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func timeAgo() -> String {
        guard let date = self.toDate() else { return "unknown" }
        
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        let minute = 60.0
        let hour = 60.0 * minute
        let day = 24.0 * hour
        
        if interval < minute {
            return "just now"
        } else if interval < hour {
            return "\(Int(interval / minute))m ago"
        } else if interval < day {
            return "\(Int(interval / hour))h ago"
        } else {
            return "\(Int(interval / day))d ago"
        }
    }
}
