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

func playMusic(_ sound: String, type: String, musicOn: Bool) {
    if musicOn {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print("Error: Couldn't find and play the sound: \(sound)")
            }
        }
    }
}

func stopMusic(_ sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.stop()
        } catch {
            print("Error: Couldn't find and stop the sound: \(sound)")
        }
    }
}
