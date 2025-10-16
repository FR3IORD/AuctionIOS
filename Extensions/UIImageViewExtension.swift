import UIKit

extension UIImageView {
    func loadImage(from url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "photo")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "photo")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
