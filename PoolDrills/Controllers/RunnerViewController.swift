//
//  RunnerViewController.swift
//  PoolDrills
//
//  Created by Marius on 2020-04-15.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class RunnerViewController: UIViewController {

    var routine: Routine?

    @IBOutlet private weak var routineTitle: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var activityButton: UIButton!
    @IBOutlet private weak var missButton: UIButton!
    @IBOutlet private weak var potButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
