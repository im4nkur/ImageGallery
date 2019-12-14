//
//  Image.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import UIKit

/// Domain model for Image.
struct Image {
    var imageData : Data
    var caption: String?
    var isExplicit: Bool
}
