//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import ImageGallery

class ImageGalleryTests: XCTestCase {
    var viewModel: GalleryViewModel?
    let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let imageRepo = ImagesMockRepo()
        let imageUseCase = ImageInteractor(repo: imageRepo)
        viewModel = GalleryViewModel(usecase: imageUseCase)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveImageAndFetch() {
        guard let viewmodel = viewModel else {
            return
        }
        
        let ex = expectation(description: "images")
        let image = ImageModel(image: UIImage(named: "Cat1")!)
        viewmodel.saveImage(image: image)
        
        viewmodel.images.asObservable().observeOn(MainScheduler.instance)
        .subscribe(onNext: { (images) in
            ex.fulfill()
            XCTAssertEqual(images.count, 1)
        }, onError: { (error) in
            ex.fulfill()
            XCTFail()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
                   if let error = error {
                       XCTFail("Error: \(error.localizedDescription)")
                   }
               }
    }
    
    func testMapUIModelToModel() {
        let mapper = ModelMapper()
        let imgModel = ImageModel(image:  UIImage(named: "Cat1")!)
        let image = mapper.mapUIModelToModel(image: imgModel)
        let convertedImageData = UIImage(data: image.imageData)!
        XCTAssertEqual(imgModel.image.size, convertedImageData.size)
    }

    func testMapModelToUIModel() {
        let mapper = ModelMapper()
        let image = Image(imageData: UIImage(named: "Cat1")!.jpegData(compressionQuality: 90)!, caption: nil, isExplicit: false)
        let imageModel = mapper.mapModelToUIModel(images: [image]).first!
        let convertedImageData = imageModel.image
        XCTAssertEqual(convertedImageData.size, UIImage(data: image.imageData)!.size)
    }
}
