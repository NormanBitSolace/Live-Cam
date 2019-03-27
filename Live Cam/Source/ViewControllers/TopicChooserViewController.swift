import UIKit

protocol TopicChooserViewControllerDelegate: class {
    func topicSelected(_ model: VideoModel)
}

final class TopicChooserViewController: UIViewController {
    weak var delegate: TopicChooserViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!

    var dataDelegate: TableViewDelegate<VideoModel, TopicCell>!
    var data: [VideoModel]? {
        didSet {
            dataDelegate.data = data
            tableView.reloadData()
        }
    }
    final override func viewDidLoad() {
        super.viewDidLoad()
        dataDelegate = TableViewDelegate(
            cellType: TopicCell.self,
            decorator: { (cell, model) in
                if let cell = cell as? TopicCell {
                    cell.titleLabel?.text = model.name
                    cell.detailLabel?.text = model.detail
                }
        }, touchDelegate: { (indexPath, model) in
            self.delegate?.topicSelected(model)
        })
        tableView.setAutoSizeHeight()
        dataDelegate.setDelegate(tableView)
    }
}
