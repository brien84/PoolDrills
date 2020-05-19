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

    private var currentIndex = -1 {
        didSet {
            currentCell = view.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DrillQueueViewCell
        }
    }

    private var currentCell: DrillQueueViewCell?

    init(view: UICollectionView) {
        self.view = view
        super.init()

        self.view.delegate = self
        self.view.dataSource = self
        self.view.isUserInteractionEnabled = false

        setupNotifications()
    }

    func next() {
        if currentIndex != datasource.indices.last {
            currentIndex += 1
            view.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    // MARK: - Notifications

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDurationNotification(_:)),
                                               name: .DurationTrackingDidUpdate,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAttemptsNotification(_:)),
                                               name: .AttemptsTrackingDidUpdate,
                                               object: nil)
    }

    @objc private func handleDurationNotification(_ notification: NSNotification) {
        guard let info = notification.userInfo as? [DurationTrackingKeys: TimeInterval] else { return }

        currentCell?.duration.text = info[.drillDuration]?.toString()
    }

    @objc private func handleAttemptsNotification(_ notification: NSNotification) {
        guard datasource[currentIndex].attempts > 0 else { return }
        guard let info = notification.userInfo as? [AttemptsTrackingKeys: Int] else { return }

        guard let attemptsLimit = info[.attemptsLimit] else { return }
        guard let hitCount = info[.hitCount] else { return }
        guard let missCount = info[.missCount] else { return }

        let attemptsLeft = attemptsLimit - hitCount - missCount
        currentCell?.attempts.text = String(attemptsLeft)
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
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrillQueueViewCell

        let drill = datasource[indexPath.row]

        cell.title.text = drill.title
        cell.duration.text = drill.duration.toString()
        cell.attempts.text = String(drill.attempts)

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
