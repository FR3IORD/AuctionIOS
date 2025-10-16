import UIKit

class SignupViewController: UIViewController {
    
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let signupButton = UIButton()
    private let errorLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Sign Up"
        view.backgroundColor = .white
        
        // ... setup all text fields and button similar to AuthViewController
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach { textField in
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
            stackView.addArrangedSubview(textField)
        }
        
        signupButton.setTitle("Create Account", for: .normal)
        signupButton.backgroundColor = .primaryBlue
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 8
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        stackView.addArrangedSubview(signupButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func signupTapped() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
            showError("Please fill in all fields correctly")
            return
        }
        
        loadingIndicator.startAnimating()
        signupButton.isEnabled = false
        
        APIManager.shared.register(firstName: firstName, lastName: lastName, username: username, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.signupButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    if response.success, let authData = response.data {
                        UserManager.shared.saveAuthToken(authData.token)
                        UserManager.shared.saveUser(authData.user)
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.textColor = .dangerRed
    }
}
