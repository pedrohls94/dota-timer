//
//  GameViewController.swift
//  Dota Timer
//
//  Created by Pedro Lenzi on 10/04/20.
//  Copyright © 2020 Pedro Lenzi. All rights reserved.
//

import UIKit
import AVFoundation

enum GameState {
    case notStarted
    case paused
    case ongoing
}

class GameViewController: UIViewController {
    private var timer: Timer?
    private var gameTimeCount = 0
    private var gameState = GameState.notStarted
    @IBOutlet weak var gameClock: UILabel!
    @IBOutlet weak var gameButtonLabel: UILabel!
    
    @IBOutlet weak var bountyTimer: UILabel!
    @IBOutlet weak var outpostTimer: UILabel!
    private var bountySecCount = 0
    private var outpostSecCount = 0
    private var bountySecTotalCount = 300
    private var outpostSecTotalCount = 600
    
    @IBOutlet weak var aegisTimer: UILabel!
    @IBOutlet weak var minRoshanTimer: UILabel!
    @IBOutlet weak var maxRoshanTimer: UILabel!
    private var aegisSecCount = 0
    private var minRoshSecCount = 0
    private var maxRoshSecCount = 0
    private var aegisSecTotalCount = 300
    private var minRoshSecTotalCount = 480
    private var maxRoshSecTotalCount = 660

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapGameButton(_ sender: UIButton) {
        switch gameState {
        case .notStarted:
            gameTimeCount = -60
            bountySecCount = 60
            outpostSecCount = outpostSecTotalCount + 60
            runTimer()
            gameState = .ongoing
            gameButtonLabel.text = "Pause"
        case .ongoing:
            timer?.invalidate()
            timer = nil
            gameState = .paused
            gameButtonLabel.text = "Resume"
        case .paused:
            runTimer()
            gameState = .ongoing
            gameButtonLabel.text = "Pause"
        }
    }
    
    @IBAction func didTapSlayRoshanButton(_ sender: UIButton) {
        aegisSecCount = aegisSecTotalCount
        minRoshSecCount = minRoshSecTotalCount
        maxRoshSecCount = maxRoshSecTotalCount
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        gameTimeCount += 1
        
        bountySecCount -= 1
        if bountySecCount == 20 {
            playSoundNamed("bounty-rune")
        } else if bountySecCount == 0 {
            bountySecCount = bountySecTotalCount
        }
        
        outpostSecCount -= 1
        if outpostSecCount == 20 {
            //TODO: alert
        } else if outpostSecCount == 0 {
            outpostSecCount = outpostSecTotalCount
        }
        
        if aegisSecCount > 0 {
            aegisSecCount -= 1
            if aegisSecCount == 10 {
                playSoundNamed("aegis-expiry")
            }
        }
        
        if minRoshSecCount > 0 {
            minRoshSecCount -= 1
            if minRoshSecCount == 10 {
                playSoundNamed("roshan-scream")
            }
        }
        
        if maxRoshSecCount > 0 {
            maxRoshSecCount -= 1
        }
        
        updateUIClocks()
    }
    
    private func updateUIClocks() {
        DispatchQueue.main.async {
            self.gameClock.text = self.secondsToTimeString(self.gameTimeCount)
            self.bountyTimer.text = self.secondsToTimeString(self.bountySecCount)
            self.outpostTimer.text = self.secondsToTimeString(self.outpostSecCount)
            self.aegisTimer.text = self.secondsToTimeString(self.aegisSecCount)
            self.minRoshanTimer.text = self.secondsToTimeString(self.minRoshSecCount)
            self.maxRoshanTimer.text = self.secondsToTimeString(self.maxRoshSecCount)
        }
    }
    
    func secondsToTimeString(_ seconds: Int) -> String {
        let positiveSeconds = abs(seconds)
        let min = positiveSeconds / 60
        let sec = positiveSeconds % 60
        return "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }
    
    var player: AVAudioPlayer?
    private func playSoundNamed(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
