//
//  PlaySound.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?
var soundOn: Bool = true

func playSound(_ sound: String, type: String) {
    if soundOn {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Error: Couldn't find and play the sound: \(sound)")
            }
        }
    }
}

func toggleSound() {
    soundOn = !soundOn
}
