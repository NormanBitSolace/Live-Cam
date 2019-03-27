import UIKit
import WebKit

class VideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var videoId: String? {
        didSet {
            if let id = videoId {
                let url = URL(string: "https://www.youtube.com/embed/\(id)?autoplay=1")!
                webView.load(URLRequest(url: url))
            }
        }
    }
}
