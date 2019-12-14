//
//  ModelConverter.swift
//  ImageGallery
//
//  Created by Ankur Arya on 16/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import UIKit

class ModelMapper {
    
     func mapModelToUIModel(images: [Image]) -> [ImageModel] {
        return images.map({ ImageModel(image: UIImage(data: $0.imageData) ?? UIImage()) })
    }
    
    func mapUIModelToModel(image: ImageModel) -> Image {
        return Image(imageData: image.image.jpegData(compressionQuality: 90) ?? Data(), caption: nil, isExplicit: false)
    }
}
