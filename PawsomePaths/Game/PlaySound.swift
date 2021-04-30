//
//  PlaySound.swift
//  Hex
//
//  Created by Duong Pham on 3/10/21.
//

import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    var soundPlayer: AVAudioPlayer?
    var musicPlayer: AVAudioPlayer?
    @Published private(set) var musicOn = false
    @Published private (set) var soundOn = false

    func playSound(_ sound: String, type: String) {
        if soundOn {
            if let path = Bundle.main.path(forResource: sound, ofType: type) {
                do {
                    soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    soundPlayer?.play()
                } catch {
                    print("Error: Couldn't find and play the sound: \(sound)")
                }
            }
        }
    }

    func playMusic(_ sound: String, type: String) {
        if musicOn {
            if let path = Bundle.main.path(forResource: sound, ofType: type) {
                do {
                    musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    musicPlayer?.numberOfLoops = -1
                    musicPlayer?.play()
                } catch {
                    print("Error: Couldn't find and play the sound: \(sound)")
                }
            }
        }
    }

    func stopMusic(_ sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                musicPlayer?.stop()
            } catch {
                print("Error: Couldn't find and stop the sound: \(sound)")
            }
        }
    }
    
    func toggleSound() {
        soundOn = !soundOn
    }
    
    func toggleMusic() {
        musicOn = !musicOn
    }
}

