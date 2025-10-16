// MARK: - 👤 UserManager.swift - მომხმარებლის მენეჯმენტი

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "auth_token"
    private let userKey = "user_data"
    
    private init() {}
    
    // MARK: - Authentication State
    
    func isLoggedIn() -> Bool {
        return getAuthToken() != nil
    }
    
    func saveAuthToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }
    
    func getAuthToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func logout() {
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.removeObject(forKey: userKey)
        
        // მთავარ ფანჯარაზე გადასვლა
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let authVC = AuthViewController()
                let navController = UINavigationController(rootViewController: authVC)
                window.rootViewController = navController
            }
        }
    }
    
    func updateUserBalance(_ balance: Double) {
        if var user = getUser() {
            user.balance = balance
            saveUser(user)
        }
    }
}
