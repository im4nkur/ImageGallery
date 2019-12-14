//
//  GalleryViewController.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    var viewModel: GalleryViewModel?
    let disposeBag = DisposeBag()
    let cellWidth = (UIScreen.main.bounds.size.width / 3) - 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let imageRepo = ImagesDBRepo()
        let imageUseCase = ImageInteractor(repo: imageRepo) // use this if you want only base functionality.
        let analyticsDecorator = AnalyticsDecorator(usecase: imageUseCase) // use this if you want to log analytics
        viewModel = GalleryViewModel(usecase: analyticsDecorator)
        setupBinding()
        setupCollectionView()
    }
    
    private func setupBinding() {
        guard let viewmodel = self.viewModel else { return }
        viewmodel.getImages()
        viewmodel.images.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (images) in
                self?.collectionView.isHidden = images.isEmpty
                self?.addButton.isHidden = !images.isEmpty
                self?.navigationItem.rightBarButtonItem = images.isEmpty ? nil : self?.getAddButton()
                self?.collectionView.reloadData()
            }, onError: { (error) in
                
            }).disposed(by: disposeBag)
        
        addButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] in
            self?.showImagePickerActionSheet()
        }).disposed(by: disposeBag)
    }

    private func getAddButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        button.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.showImagePickerActionSheet()
            }).disposed(by: disposeBag)
        return button
    }
    
    private func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        collectionView.collectionViewLayout = flowLayout
        guard let viewmodel = self.viewModel else { return }
        viewmodel.images.asObservable().bind(to: collectionView.rx.items(
            cellIdentifier: String(describing: GalleryCollectionViewCell.self),
            cellType: GalleryCollectionViewCell.self)) { (index, image, cell) in
                cell.imageView?.image = image.image
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.asObservable().subscribe(onNext: { ( index ) in
            let router = ImageDetailsRouter(viewController: self)
            let presenter = ImageDetailsRouterPresenter(router: router)
            presenter.showImageDetails(images: viewmodel.images.value, index: index)
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: "Pick Image", message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePicker(source: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
           #if targetEnvironment(simulator)
            self.showWarningAlert()
           #else
             self.showImagePicker(source: .camera)
           #endif
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    private func showImagePicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = source
        picker.delegate = self
        self.present(picker, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let croppedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            viewModel?.saveImage(image: ImageModel(image: croppedImage))
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showWarningAlert() {
        let alert = UIAlertController(title: "Unavailable", message: "Camera is not available on simulator.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
