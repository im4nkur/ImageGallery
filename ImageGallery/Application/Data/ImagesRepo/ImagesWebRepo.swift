//
//  ImagesWebRepo.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class ImagesWebRepo: ImageRepo {
    func saveImage(image: Image) {
        // Implement your web service to save image.
    }
    
    func fetchImages() -> Observable<[Image]> {
        return Observable.create({ observer in
            let images = [Image]()
             // Implement your web service to fetch images.
            observer.onNext(images)
            return Disposables.create {}
        }) 
    }
}
