//
//  ImageRepo.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift

/// Protocol for Image Repo
protocol ImageRepo {
    
    /// Fetch images from source
    /// - returns: RxSwift observable of images array.
    func fetchImages() -> Observable<[Image]>
    
    /// Save image
    /// - Parameter image: domain model of image.
    func saveImage(image: Image)
}
