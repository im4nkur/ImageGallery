//
//  FIIDecorator.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation

protocol ImageDecorator : ImageUseCase {
    var usecase: ImageUseCase { get }
}
