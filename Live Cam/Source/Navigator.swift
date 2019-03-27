import UIKit

public typealias Configure<T> = ((T) -> Swift.Void)?
public typealias Completion = (() -> Swift.Void)?

public class Navigator: NSObject {

    var window: UIWindow!
    var rootNavigationController: UINavigationController!
    var topViewController: UIViewController? {
        return rootNavigationController.topViewController
    }

//    @discardableResult
//    func start<T: UIViewController>(vc: T.Type, configure: Configure<T>) -> T {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window.backgroundColor = UIColor.white
//        let rootVC = T.init()
//        rootVC.edgesForExtendedLayout = []
//        rootVC.extendedLayoutIncludesOpaqueBars = false
//        self.rootNavigationController = UINavigationController(rootViewController: rootVC)
//        window.rootViewController = rootNavigationController
//        window.makeKeyAndVisible()
//        // rootNavigationController is rootViewController and it's the place rootVC should get it's frame from
//        rootNavigationController.applyConfig(rootVC, configure: configure)
//        return rootVC
//    }

    @discardableResult
    func start<T: UIViewController>(vc: T.Type, storyboardName: String? = nil, configure: Configure<T>) -> T {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        var rootVC: T
        if let name = storyboardName {
            rootVC = UIViewController.loadStoryboard(name)
        } else {
            rootVC = T.init()
        }
        if let navigationController = rootVC.navigationController {
            rootNavigationController = navigationController
        } else {
            rootNavigationController = UINavigationController(rootViewController: rootVC)
        }
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        rootNavigationController.applyConfig(rootVC, configure: configure)
        return rootVC
    }

    var useLargeNavigation: Bool = true {
        didSet {
            if useLargeNavigation {
                rootNavigationController.navigationBar.prefersLargeTitles = true
                rootNavigationController.navigationItem.largeTitleDisplayMode = .always
                rootNavigationController.navigationBar.isTranslucent = false
            } else {
                rootNavigationController.navigationBar.prefersLargeTitles = false
                //                rootNavigationController.navigationItem.largeTitleDisplayMode = .never
            }
        }
    }
}

extension Navigator {   // PUSH

    @discardableResult
    public func push<T: UIViewController>(animated: Bool = true, configure: Configure<T>? = nil) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        return push(vc: vc, animated: animated, configure: configure)
    }

    @discardableResult
    public func push<T: UIViewController>(storyboardName: String, animated: Bool = true, configure: Configure<T>? = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return push(vc: vc, animated: animated, configure: configure)
    }

    @discardableResult
    func push<T: UIViewController>(vc: T, animated: Bool = true, configure: Configure<T>? = nil) -> T {
        if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        rootNavigationController.pushViewController(vc, animated: animated)
        return vc
    }
}

extension Navigator {   //  MODAL

    @discardableResult
    public func presentModal<T: UIViewController>(animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        _ = UINavigationController.init(rootViewController: vc)
        return presentModal(vc: vc, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    public func presentModal<T: UIViewController>(storyboardName: String, wrap: Bool = false, animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        if wrap {
            _ = UINavigationController.init(rootViewController: vc)
        }
        return presentModal(vc: vc, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    func presentModal<T: UIViewController>(vc: T, animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        rootNavigationController.applyConfig(vc, configure: configure)
        let target = vc.navigationController ?? vc
        rootNavigationController.present(target, animated: animated, completion: completion)
        return vc
    }
}

extension Navigator {   //  POPOVER

    @discardableResult
    public func presentPopover<T: UIViewController>(anchor: Any, animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        return presentPopover(vc: vc, anchor: anchor, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    public func presentPopover<T: UIViewController>(storyboardName: String, anchor: Any, animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return presentPopover(vc: vc, anchor: anchor, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    func presentPopover<T: UIViewController>(vc: T, anchor: Any, animated: Bool = true, completion: Completion = nil, configure: Configure<T>) -> T {
        let target = vc.navigationController ?? vc
        target.modalPresentationStyle = .popover
        rootNavigationController.applyPopoverConfig(vc, anchor: anchor)
        rootNavigationController.applyConfig(vc, configure: configure)
        topViewController?.present(target, animated: animated, completion: completion)
        //  TODO figure out why vc vs nvc
//        rootNavigationController.presentedViewController?.present(target, animated: animated, completion: completion)
        return vc
    }
}

extension Navigator {   //  CHILD

    @discardableResult
    public func addChildViewController<T: UIViewController>(container: UIViewController? = nil, animated: Bool = true, configure: Configure<T>) -> T {
        let vc = T.init()
        return addChildViewController(vc: vc, container: container, animated: animated, configure: configure)
    }

    @discardableResult
    public func addChildViewController<T: UIViewController>(storyboardName: String, container: UIViewController? = nil, animated: Bool = true, configure: Configure<T>) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return addChildViewController(vc: vc, container: container, animated: animated, configure: configure)
    }

    func addChildViewController<T: UIViewController>(vc: T, container: UIViewController? = nil, animated: Bool = true, configure: Configure<T>) -> T {
        guard let topVC = topViewController else { preconditionFailure("App assumes a top view controller.")}
        let parentVC = container == nil ? topVC : container!
        parentVC.addChild(vc)
        rootNavigationController.applyConfig(vc, configure: configure)
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
        return vc
    }
    func removeChildViewController(childViewController vc: UIViewController) {
        DispatchQueue.main.async {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
}

extension UIViewController {

    static func loadStoryboard<T: UIViewController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        if let navigationController = vc as? UINavigationController,
            let vc = navigationController.topViewController as? T {
            return vc
        } else if let vc = vc as? T {
            return vc
        } else {
            fatalError(
                """

                    --- Storyboard must have Custom Class set to \(T.description()). ---
                    --- Storyboard must have Is Initial View Controller option set to on. ---


                    """
            )
        }
    }

    func applyConfig<T: UIViewController>(_ vc: T, configure: Configure<T>) {
        vc.view.frame = view.bounds
        if let configure = configure {
            vc.loadViewIfNeeded()
            configure(vc)
        }
    }

    var popoverDelegateErrorMessage: String {
        return """


        --- A popover view controller must derive from PopoverViewController OR implement: ---

        extension ViewController: UIPopoverPresentationControllerDelegate {

        public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
        }

        public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        }
        }

        """
    }

    func applyPopoverConfig(_ vc: UIViewController, anchor: Any) {
        guard let popoverDelegate = vc as? UIPopoverPresentationControllerDelegate else { fatalError(popoverDelegateErrorMessage) }
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = popoverDelegate
        if let barButtonItem = anchor as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let sourceView = anchor as? UIView {
            vc.popoverPresentationController?.sourceView = sourceView
            vc.popoverPresentationController?.sourceRect = sourceView.bounds
        }
    }
}

extension Navigator {   //  ALERT

    func singleButtonAlert(buttonLabel: String, title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonLabel, style: .default, handler: handler)
        alertController.addAction(okAction)
        rootNavigationController.present(alertController, animated: true, completion: nil)
    }
}
