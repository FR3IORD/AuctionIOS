// MARK: - 📱 iOS Auction App for AuctionBay Platform
//
// ინსტრუქციები:
// 1. Xcode-ში შექმენით ახალი iOS პროექტი (Single View App)
// 2. პროექტის სახელი: "AuctionBay"
// 3. Bundle Identifier: ge.auctionbay.ios
// 4. Language: Swift
// 5. Interface: Storyboard ან SwiftUI

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // მთავარი ფანჯრის კონფიგურაცია
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // API Manager-ის ინიციალიზაცია
        APIManager.shared.initialize()
        
        // მთავარი კონტროლერის სეტაპი
        let initialVC = UserManager.shared.isLoggedIn() ? createMainTabController() : createAuthController()
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func createMainTabController() -> UITabBarController {
        let tabController = UITabBarController()
        
        // Tab Bar სტილი
        tabController.tabBar.backgroundColor = UIColor.white
        tabController.tabBar.tintColor = UIColor.systemBlue
        
        // Auctions Tab
        let auctionsVC = AuctionsViewController()
        let auctionsNav = UINavigationController(rootViewController: auctionsVC)
        auctionsNav.tabBarItem = UITabBarItem(title: "Auctions", image: UIImage(systemName: "hammer"), tag: 0)
        
        // Live Auctions Tab
        let liveVC = LiveAuctionsViewController()
        let liveNav = UINavigationController(rootViewController: liveVC)
        liveNav.tabBarItem = UITabBarItem(title: "Live", image: UIImage(systemName: "play.circle"), tag: 1)
        
        // Account Tab
        let accountVC = AccountViewController()
        let accountNav = UINavigationController(rootViewController: accountVC)
        accountNav.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.circle"), tag: 2)
        
        // My Tickets Tab
        let ticketsVC = MyTicketsViewController()
        let ticketsNav = UINavigationController(rootViewController: ticketsVC)
        ticketsNav.tabBarItem = UITabBarItem(title: "Tickets", image: UIImage(systemName: "ticket"), tag: 3)
        
        tabController.viewControllers = [auctionsNav, liveNav, accountNav, ticketsNav]
        
        return tabController
    }
    
    private func createAuthController() -> UINavigationController {
        let authVC = AuthViewController()
        return UINavigationController(rootViewController: authVC)
    }
}
