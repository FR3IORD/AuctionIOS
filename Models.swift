// MARK: - 📱 Data Models - ყველა API Response მოდელი

import Foundation

struct AuthResponse: Codable {
    let success: Bool
    let data: AuthData?
    let message: String?
}

struct AuthData: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    var balance: Double
    let isAdmin: Bool
    let status: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, balance, status
        case firstName = "first_name"
        case lastName = "last_name"
        case isAdmin = "is_admin"
        case createdAt = "created_at"
    }
}

struct AuctionsResponse: Codable {
    let success: Bool
    let data: AuctionsData?
    let message: String?
}

struct AuctionsData: Codable {
    let auctions: [Auction]
    let count: Int
}

struct Auction: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let imageUrl: String?
    let startTime: String
    let endTime: String
    let ticketPrice: Double
    let totalTickets: Int
    let ticketsSold: Int
    let bidsPerTicket: Int
    let guaranteed: Bool
    let status: String
    let winnerId: Int?
    let winnerUsername: String?
    let participantCount: Int?
    let totalBids: Int?
    let isActive: Bool?
    let isUpcoming: Bool?
    let isEnded: Bool?
    let timeRemaining: Int?
    let ticketsRemaining: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, status
        case imageUrl = "image_url"
        case startTime = "start_time"
        case endTime = "end_time"
        case ticketPrice = "ticket_price"
        case totalTickets = "total_tickets"
        case ticketsSold = "tickets_sold"
        case bidsPerTicket = "bids_per_ticket"
        case guaranteed
        case winnerId = "winner_id"
        case winnerUsername = "winner_username"
        case participantCount = "participant_count"
        case totalBids = "total_bids"
        case isActive = "is_active"
        case isUpcoming = "is_upcoming"
        case isEnded = "is_ended"
        case timeRemaining = "time_remaining"
        case ticketsRemaining = "tickets_remaining"
    }
}

struct AuctionDetailResponse: Codable {
    let success: Bool
    let data: AuctionDetailData?
    let message: String?
}

struct AuctionDetailData: Codable {
    let auction: Auction
}

struct BidResponse: Codable {
    let success: Bool
    let data: BidData?
    let message: String?
}

struct BidData: Codable {
    let bidId: Int
    let remainingBids: Int
    let auctionId: Int
    
    enum CodingKeys: String, CodingKey {
        case bidId = "bid_id"
        case remainingBids = "remaining_bids"
        case auctionId = "auction_id"
    }
}

struct UserProfileResponse: Codable {
    let success: Bool
    let data: UserProfileData?
    let message: String?
}

struct UserProfileData: Codable {
    let user: User
}

struct TransactionsResponse: Codable {
    let success: Bool
    let data: TransactionsData?
    let message: String?
}

struct TransactionsData: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable, Identifiable {
    let id: Int
    let userId: Int
    let type: String
    let amount: Double
    let status: String
    let description: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, amount, status, description
        case userId = "user_id"
        case createdAt = "created_at"
    }
}
