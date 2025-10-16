import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let signupButton = UIButton()
    private let errorLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Login"
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Email TextField
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailTextField)
        
        // Password TextField
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordTextField)
        
        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .primaryBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        contentView.addSubview(loginButton)
        
        // Signup Button
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.primaryBlue, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        contentView.addSubview(signupButton)
        
        // Error Label
        errorLabel.textColor = .dangerRed
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        contentView.addSubview(errorLabel)
        
        // Loading Indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingIndicator)
        
        // Constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        // ScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentView constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Email TextField
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Password TextField
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Login Button
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Signup Button
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Error Label
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Loading Indicator
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please fill in all fields")
            return
        }
        
        loadingIndicator.startAnimating()
        loginButton.isEnabled = false
        
        APIManager.shared.login(email: email, password: password) { [weak self] result in
            self?.loadingIndicator.stopAnimating()
            self?.loginButton.isEnabled = true
            
            switch result {
            case .success(let response):
                if response.success, let authData = response.data {
                    UserManager.shared.saveAuthToken(authData.token)
                    UserManager.shared.saveUser(authData.user)
                    
                    // Navigate to main app
                    DispatchQueue.main.async {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            window.rootViewController = appDelegate?.window?.rootViewController
                        }
                    }
                } else {
                    self?.showError(response.message ?? "Login failed")
                }
            case .failure(let error):
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    @objc private func signupTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
