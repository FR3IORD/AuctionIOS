import UIKit

class AccountViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let balanceLabel = UILabel()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupUI() {
        title = "Account"
        view.backgroundColor = .white
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        balanceLabel.font = UIFont.systemFont(ofSize: 16)
        balanceLabel.textColor = .systemGreen
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceLabel)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .dangerRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 8
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            balanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateUI() {
        if let user = UserManager.shared.getUser() {
            nameLabel.text = "\(user.firstName) \(user.lastName)"
            balanceLabel.text = "Balance: \(user.balance.formatAsCurrency())"
        }
    }
    
    @objc private func logoutTapped() {
        UserManager.shared.logout()
    }
}
