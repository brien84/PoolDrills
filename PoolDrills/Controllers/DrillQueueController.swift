//
//  DrillQueueController.swift
//  PoolDrills
//
//  Created by Marius on 2020-05-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DrillQueueController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var datasource = [Drill]() {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }

    private var currentIndex = -1 {
        didSet {
            currentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DrillQueueViewCell
        }
    }

    private var currentCell: DrillQueueViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isUserInteractionEnabled = false

        setupNotifications()
    }

    func next() {
        if currentIndex != datasource.indices.last {
            currentIndex += 1
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drillQueueCell", for: indexPath) as! DrillQueueViewCell

        let drill = datasource[indexPath.row]

        cell.title.text = drill.title
        cell.duration.text = drill.duration.toString()
        cell.attempts.text = String(drill.attempts)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellWidth, bottom: 0, right: cellWidth)
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
    private var cellHeight: CGFloat { collectionView.frame.height }
    private var cellWidth: CGFloat { collectionView.frame.width }
}
