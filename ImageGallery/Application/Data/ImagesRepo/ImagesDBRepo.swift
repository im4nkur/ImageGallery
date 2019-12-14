//
//  ImagesDBRepo.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import RxCocoa

struct DataBaseKeys {
    static let entityName = "ImageCD"
    static let imageAttribute = "imageData"
    static let captionAttribute = "caption"
    static let isExplicitAttribute = "isExplicit"
}

/// Images data base repo.
class ImagesDBRepo: ImageRepo {
    
    /// Save image to Core Data.
    /// - Parameter image: domain model of image.
    func saveImage(image: Image) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let imageEntity = NSEntityDescription.entity(forEntityName: DataBaseKeys.entityName, in: managedContext)!
        let imageCD = NSManagedObject(entity: imageEntity, insertInto: managedContext)
        imageCD.setValue(image.imageData, forKeyPath: DataBaseKeys.imageAttribute)
        imageCD.setValue(image.caption, forKeyPath: DataBaseKeys.captionAttribute)
        imageCD.setValue(image.isExplicit, forKeyPath: DataBaseKeys.isExplicitAttribute)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /// Fetch images from Core Data
    /// - returns: RxSwift observable of images array.
    func fetchImages() -> Observable<[Image]> {
        return Observable.create({ observer in
            var images = [Image]()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Disposables.create {} }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DataBaseKeys.entityName)
            do {
                if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                    for data in result {
                        if let image = self.convertManagedObjectToDomainObject(mo: data) {
                            images.append(image)
                        }
                    }
                    observer.onNext(images)
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create {}
        })
    }
    
    /// Convert Managed Object to domain model.
    /// - Parameter mo: Managed Object which contains data from Core data.
    /// - Returns: Image model.
    private func convertManagedObjectToDomainObject(mo: NSManagedObject) -> Image? {
        guard let imageData = mo.value(forKey: DataBaseKeys.imageAttribute) as? Data,
            let isExplicit = mo.value(forKey: DataBaseKeys.isExplicitAttribute) as? Bool else { return nil }
        let caption = mo.value(forKey: DataBaseKeys.captionAttribute) as? String
        return Image(imageData:imageData, caption: caption, isExplicit: isExplicit)
    }
}
