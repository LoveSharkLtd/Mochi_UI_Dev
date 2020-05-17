//
//  Utilities.swift
//  Mochi
//
//  Created by Sam Weekes on 5/17/20.
//  Copyright © 2020 Sam Weekes. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}




/* HAPTIC FEEDBACK */
enum hapticType {
    case light
    case medium
    case heavy
}
var allowHaptics : Bool = true // will allow settings to turn off haptics (maybe as a "low power mode")

func runHaptic(_ type : hapticType) {
    // runs haptic feedback for things like button presses etc.
    // Will use UIImpactFeedbackGenerator for 7 / 7+ devices and above
    // Has fallback for 6s / 6s+ and below devices
    // Has option for disabling haptics throughout the app (for say settings)
    if (!allowHaptics) { return }
    if (UIDevice.isHapticsSupported) {
        var haptic = UIImpactFeedbackGenerator.FeedbackStyle.light
        if type == .medium {
            haptic = UIImpactFeedbackGenerator.FeedbackStyle.medium
        } else if type == .heavy {
            haptic = UIImpactFeedbackGenerator.FeedbackStyle.heavy
        }
        let feedback = UIImpactFeedbackGenerator(style: haptic)
        feedback.prepare()
        feedback.impactOccurred()
    } else {
        let haptic : SystemSoundID = type == .light ? 1519 : (type == .medium ? 1520 : 1521)
        AudioServicesPlaySystemSound(haptic)
    }
}

extension UIDevice {
    // Checks whether the device supports UIImpactFeedbackGenerator (7 / 7+ devices and above)
    static var isHapticsSupported : Bool {
        let feedback = UIImpactFeedbackGenerator(style: .heavy)
        feedback.prepare()
        var string = feedback.debugDescription
        string.removeLast()
        let number = string.suffix(1)
        return number == "1"
    }
}
