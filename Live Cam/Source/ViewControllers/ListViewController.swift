import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableViewDelegate: TableViewDelegate<String, UITableViewCell>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = ["Love", "Peas", "Harmony"]
        tableViewDelegate = TableViewDelegate(data: data,
            decorator: { (cell, model) in
                cell.textLabel?.text = model
            }, touchDelegate: { (indexPath, model) in
                print(model)
            })
        tableViewDelegate.setDelegate(tableView)
    }
 }
