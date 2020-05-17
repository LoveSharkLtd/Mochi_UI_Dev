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

/* Device Vars */
var sH : CGFloat = 0.0 // screen height
var sW : CGFloat = 0.0 // screen width
var sHR : CGFloat = 0.0 // corrected screen height, mainly for iPhone X dimensions
var sHP : CGFloat = 0.0 // height for presentViewController : normal devices = sH : tall devices = sH * 758 / 812 : iPads = 1006 x 712
var sWP : CGFloat = 0.0 // only really different for ipads

var _deviceType : deviceType = .normal // what device is being used - for adding padding to top and bottom as and when needed - also to set maximum widths for ipads.

enum deviceType {
    case normal // any non iPad / non iPhone X type device
    case tall // any iPhone X type device
    case iPad // any iPad type device
}

func updateScreenScales() {
    sW = UIScreen.main.bounds.size.width
    sH = UIScreen.main.bounds.size.height
    sHR = sH * (1920.0 / 1080.0) / (sH / sW)
    if (sHR / sH > 1.1) { sHR = sH * (4 / 3) / (sH / sW) }
    sWP = sW
    sHP = sH
    
    let _sHR = (1920 / 1080) / (sH / sW)
    
    if _sHR < 0.9 {
        _deviceType = .tall
        if #available(iOS 13.0, *) {
            sHP = sH * 758.0 / 812.0
        }
    } else if _sHR > 1.1 {
        _deviceType = .iPad
        sHR = sH
        if #available(iOS 13.0, *) {
            // until apple sorts it's crap out we can't use !fullscreen modals for the modal VCs
//                sHP = sH * 1006 / 1194
//                sWP = sW * 712 / 834
        }
    }
    
}

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

extension UIColor {
    func desaturateAndBrighten(saturation : CGFloat, brightness : CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return UIColor(hue : h, saturation : saturation, brightness : brightness, alpha : 1.0)
    }
}

extension UIView {
    
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours : colours, locations: nil, true)
    }
    func applyGradientHorizontal(colours: [UIColor]) {
        self.applyGradient(colours : colours, locations: nil, false)
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?,_ isVertical : Bool) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if (!isVertical) {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientRadial(colours : [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.type = .radial
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func glow(color : UIColor, size : CGFloat?) {
        let radius = size == nil ? 5.0 : size!
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize()
        layer.shadowRadius = radius
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: sHR * 20 / 667).cgPath
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale = 1
    }
    
    
    func fade(alpha : CGFloat, duration : Double, delay : Double) {
        if (self.alpha == 0.0) {
            self.isHidden = false
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = alpha
        }) { (_) in
            self.isHidden = alpha == 0.0
        }
    }
}
