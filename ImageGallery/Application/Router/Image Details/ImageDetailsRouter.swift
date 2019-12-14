import UIKit

protocol ImageDetailsRouterProtocol {
    func showImageDetails(images: [ImageModel], index: IndexPath)
}

/// Router for image detail screen.
class ImageDetailsRouter: ImageDetailsRouterProtocol {
    private var presentingViewController: UIViewController?
    
    init(viewController: UIViewController) {
        presentingViewController = viewController
    }
    
    /// Show image on full screen view.
    /// - Parameters:
    ///   - images: images array to show carousal of images.
    ///   - index: index of tapped image.
    internal func showImageDetails(images: [ImageModel], index: IndexPath) {
        guard let navigationController = presentingViewController?.navigationController else {
            assertionFailure("Navigation Controller not found.")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageDetailsViewController = storyboard.instantiateViewController(withIdentifier: String(describing: FullImageViewController.self)) as? FullImageViewController {
            imageDetailsViewController.index = index
            imageDetailsViewController.images.accept(images)
            navigationController.present(imageDetailsViewController, animated: true)
            
        }
    }
}
