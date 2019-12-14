//
//  FullImageViewController.swift
//  ImageGallery
//
//  Created by Ankur Arya on 14/12/19.
//  Copyright © 2019 Ankur Arya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FullImageViewController: UIViewController , UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var index: IndexPath?
    var images = BehaviorRelay<[ImageModel]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        cellHeight = collectionView.bounds.size.height - 100
        cellWidth = collectionView.frame.size.width
        setupBinding()
        setupCollectionView()
    }
    
    private func setupBinding() {
        images.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (images) in
                self?.collectionView.isHidden = images.isEmpty
                self?.collectionView.reloadData()
                }, onError: { (error) in
                    
            }).disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        images.asObservable().bind(to: collectionView.rx.items(
            cellIdentifier: String(describing: GalleryCollectionViewCell.self),
            cellType: GalleryCollectionViewCell.self)) { (index, image, cell) in
                cell.imageView?.image = image.image
        }.disposed(by: disposeBag)
        guard let selectedIndex = index else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.collectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
