import UIKit

final class AppCoordinator: NSObject {

    let navigator: Navigator
    let dataService: DataService

    init(appNavigator: Navigator, dataService: DataService) {
        self.navigator = appNavigator
        self.dataService = dataService
    }

    func start() {
        navigator.start(vc: TopicChooserViewController.self, storyboardName: "TopicChooser") { vc in
            vc.delegate = self
            self.dataService.videoModels { models in
                vc.data = models
            }
        }
    }

    func showList() {
        let _: ListViewController = navigator.push(storyboardName: "List")
    }

    func showVideo(model: VideoModel) {
        let _: VideoViewController = navigator.push(storyboardName: "Video", animated: true) { vc in
            vc.videoId = model.id
        }
    }
}

extension AppCoordinator: TopicChooserViewControllerDelegate {
    func topicSelected(_ model: VideoModel) {
        showVideo(model: model)
//        showList()
    }

}
