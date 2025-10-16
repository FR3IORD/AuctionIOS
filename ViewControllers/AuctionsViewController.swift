import UIKit

class AuctionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var auctions: [Auction] = []
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAuctions()
    }
    
    private func setupUI() {
        title = "Auctions"
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AuctionCell.self, forCellReuseIdentifier: "AuctionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadAuctions() {
        loadingIndicator.startAnimating()
        
        APIManager.shared.fetchAuctions { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let response):
                    self?.auctions = response.data?.auctions ?? []
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auctions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuctionCell", for: indexPath) as! AuctionCell
        cell.configure(with: auctions[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = AuctionDetailViewController(auction: auctions[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class AuctionCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .systemGreen
        contentView.addSubview(priceLabel)
        
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = .gray
        contentView.addSubview(statusLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with auction: Auction) {
        titleLabel.text = auction.title
        priceLabel.text = auction.ticketPrice.formatAsCurrency() + " per ticket"
        statusLabel.text = "Status: \(auction.status)"
    }
}
