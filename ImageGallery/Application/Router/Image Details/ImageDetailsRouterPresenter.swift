import UIKit

protocol ImageDetailsRouterPresenterProtocol {
    func showImageDetails(images: [ImageModel], index: IndexPath)
}

class ImageDetailsRouterPresenter: ImageDetailsRouterPresenterProtocol {

    func showImageDetails(images: [ImageModel], index: IndexPath) {
        self.router?.showImageDetails(images: images, index: index)
    }
    
    var router: ImageDetailsRouterProtocol?

    init(router: ImageDetailsRouterProtocol) {
        self.router = router
    }
}
