//
//  ImageInteractor.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift

class ImageInteractor: ImageUseCase {
    let imageRepo: ImageRepo
    
    init(repo: ImageRepo) {
        self.imageRepo = repo
    }
    
    /// Fetch images from source, uses give repo to perform fetch.
    /// - returns: RxSwift observable of images array.
    func fetchImages() -> Observable<[Image]> {
        // business logic
        return imageRepo.fetchImages().map { (images) -> [Image] in
            return images.filter({!$0.isExplicit})
        }
    }
    /// Save image, uses give repo to perform save.
    /// - Parameter image: domain model of image.
    func saveImage(image: Image) {
        imageRepo.saveImage(image: image)
    }
    
}
