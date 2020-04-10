//
//  GameViewControllerTest.swift
//  Dota TimerTests
//
//  Created by Pedro Lenzi on 10/04/20.
//  Copyright © 2020 Pedro Lenzi. All rights reserved.
//

import XCTest
@testable import Dota_Timer

class GameViewControllerTest: XCTestCase {
    func testSecondsToTimeString() {
        let gameVC = GameViewController()
        assert(gameVC.secondsToTimeString(5) == "00:05")
        assert(gameVC.secondsToTimeString(10) == "00:10")
        assert(gameVC.secondsToTimeString(60) == "01:00")
        assert(gameVC.secondsToTimeString(65) == "01:05")
        assert(gameVC.secondsToTimeString(6000) == "100:00")
    }
}
