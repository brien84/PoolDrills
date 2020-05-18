//
//  DrillQueueController.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class DrillQueueController: NSObject {

    private let view: UICollectionView

    var datasource = [Drill]() {
        didSet {
            view.reloadData()
            view.layoutIfNeeded()
        }
    }

    private var currentIndex = -1

    init(view: UICollectionView) {
        self.view = view
        super.init()

        self.view.delegate = self
        self.view.dataSource = self
        self.view.isUserInteractionEnabled = false
    }

    func next() {
        if currentIndex != datasource.indices.last {
            currentIndex += 1
            view.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

}

extension DrillQueueController {
    fileprivate var cellHeight: CGFloat { view.frame.height - 20 }
    fileprivate var cellWidth: CGFloat { view.frame.width / 2 }
}

extension DrillQueueController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
}

extension DrillQueueController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellWidth, bottom: 0, right: cellWidth)
    }

}
