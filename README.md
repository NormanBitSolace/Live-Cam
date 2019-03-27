# Live-Cam
A list of live feeds is presented, touching any of the displayed rows shows the live cam feed (e.g. an eagle's nest). Explores using TableViewDelegate to handle generic table view concerns.

*Generic table views are popular because:*
1. Remove boilerplate code involved in implementing tables
1. Reduce complexity
1. Reduce view controller size
1. They are fun to write

This approach is slightly different in that it creates a generic table view delegate vs. a generic table view or table view controller.

## Table View Delegate

### Simple Case

You want to display a list of strings or models without subclassing `UITableViewCell`. When instantiating `TableViewDelegate` without a cell type, a generic `UITableViewCell` is used with a `subtitle` style, this also exposes `cell.detailLabel` for decoration.
```swift
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
```

### Real World Example

Displaying models from an async source with a custom `UITableViewCell` subclass. This is the code used to implement this project.

```swift
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
            type: TopicCell.self,
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
```

### Caveats
1. It is necessary to create a `TableViewDelegate` member in the view controller to maintain a reference because `UITableView` holds `UITableViewDataSource` and `UITableViewDelegate` with weak references.
1. When instantiating `TableViewDelegate` with a cell type it is assumed the cell identifier used to dequeue is the cell type's name e.g. if the cell's type is MyCellType, the cell identifier is "MyCellType".

Swift Talk did a very interesting episode [Generic Table View Controllers](https://talk.objc.io/episodes/S01E6-generic-table-view-controllers).
