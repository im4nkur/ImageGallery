//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GalleryViewModel {
    let usecase: ImageUseCase
    var images = BehaviorRelay<[ImageModel]>(value: [])
    let disposeBag = DisposeBag()
    init(usecase: ImageUseCase) {
        self.usecase = usecase
    }
    
    func getImages() {
        usecase.fetchImages().map({ ModelMapper().mapModelToUIModel(images: $0)}).subscribe(onNext: { [weak self] (images) in
            self?.images.accept(images)
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func saveImage(image: ImageModel) {
        let imageData = ModelMapper().mapUIModelToModel(image: image)
        usecase.saveImage(image: imageData)
        getImages()
    }
}
