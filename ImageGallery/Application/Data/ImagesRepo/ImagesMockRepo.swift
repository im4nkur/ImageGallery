//
//  ImagesMockRepo.swift
//  ImageGallery
//
//  Created by Ankur Arya on 16/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ImagesMockRepo: ImageRepo {
    
    /// Save image to Core Data.
    /// - Parameter image: domain model of image.
    func saveImage(image: Image) {
        do {
             let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("image.png")
            try image.imageData.write(to: fileURL, options: .atomic)
         } catch { }
    }
    
    /// Fetch images from Core Data
    /// - returns: RxSwift observable of images array.
    func fetchImages() -> Observable<[Image]> {
        return Observable.create({ observer in
            var images = [Image]()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("image.png").path
            if FileManager.default.fileExists(atPath: filePath) {
                if let imgData = UIImage(contentsOfFile: filePath)?.jpegData(compressionQuality: 90) {
                    let image = Image(imageData: imgData, caption: nil, isExplicit: false)
                    images.append(image)
                }
                
            }
             observer.onNext(images)
            return Disposables.create {}
        })
    }
}
