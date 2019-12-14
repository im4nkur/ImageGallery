//
//  LogDecorator.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class AnalyticsDecorator: ImageDecorator  {
    var usecase: ImageUseCase
    
    init(usecase: ImageUseCase) {
        self.usecase = usecase
    }
    func fetchImages() -> Observable<[Image]> {
        sendAnalytics(name: "Fetch_Images")
        return usecase.fetchImages()
    }
    
    func saveImage(image: Image) {
        sendAnalytics(name: "Save_Images")
        usecase.saveImage(image: image)
    }
    
    func sendAnalytics(name: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: "id-\(name)",
        AnalyticsParameterItemName: name,
        AnalyticsParameterContentType: "Image"
        ])
    }
}
