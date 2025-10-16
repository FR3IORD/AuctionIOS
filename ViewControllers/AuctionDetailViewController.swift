import UIKit

class AuctionDetailViewController: UIViewController {
    
    private let auction: Auction
    private let descriptionLabel = UILabel()
    private let bidButton = UIButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    init(auction: Auction) {
        self.auction = auction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = auction.title
        view.backgroundColor = .white
        
        descriptionLabel.text = auction.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        bidButton.setTitle("Place Bid", for: .normal)
        bidButton.backgroundColor = .primaryBlue
        bidButton.setTitleColor(.white, for: .normal)
        bidButton.layer.cornerRadius = 8
        bidButton.translatesAutoresizingMaskIntoConstraints = false
        bidButton.addTarget(self, action: #selector(bidTapped), for: .touchUpInside)
        view.addSubview(bidButton)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bidButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bidButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bidButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bidButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func bidTapped() {
        loadingIndicator.startAnimating()
        bidButton.isEnabled = false
        
        APIManager.shared.placeBid(auctionId: auction.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.bidButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    if response.success {
                        let alert = UIAlertController(title: "Success", message: "Bid placed successfully!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
