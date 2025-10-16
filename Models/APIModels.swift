import Foundation

struct RecentBid: Codable {
    let bidId: Int
    let username: String
    let bidTime: String
    
    enum CodingKeys: String, CodingKey {
        case bidId = "bid_id"
        case username
        case bidTime = "bid_time"
    }
}

struct LeaderboardEntry: Codable {
    let userId: Int
    let username: String
    let firstName: String
    let lastName: String
    let bidCount: Int
    let lastBidTime: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bidCount = "bid_count"
        case lastBidTime = "last_bid_time"
    }
}

struct AuctionData: Codable {
    let leaderboard: [LeaderboardEntry]
    let recentBids: [RecentBid]
    let totalBids: Int
    let onlineUsers: Int
    let userRemainingBids: Int
    let userBalance: Double
    
    enum CodingKeys: String, CodingKey {
        case leaderboard
        case recentBids = "recent_bids"
        case totalBids = "total_bids"
        case onlineUsers = "online_users"
        case userRemainingBids = "user_remaining_bids"
        case userBalance = "user_balance"
    }
}

struct AddFundsResponse: Codable {
    let success: Bool
    let newBalance: Double
    let transactionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case newBalance = "new_balance"
        case transactionId = "transaction_id"
    }
}
