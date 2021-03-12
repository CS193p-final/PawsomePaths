//
//  PlaySound.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(_ sound: String, type: String, soundOn: Bool) {
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
