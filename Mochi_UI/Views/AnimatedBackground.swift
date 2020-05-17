//
//  AnimatedBackground.swift
//  Mochi_UI
//
//  Created by Sam Weekes on 5/17/20.
//  Copyright © 2020 Sam Weekes. All rights reserved.
//

import Foundation
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
class AnimatedBackground: UIView {
    override init(frame: CGRect) { super.init(frame: frame)}
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var foregroundColors : [UIColor] = [] //
    var mochiBackgroundColors : [UIColor] = []
    
    let rowMaxHeight : CGFloat = 168.0
    let gapVertical : CGFloat = 36.0
    let gapHorizontal : CGFloat = 28.0
    
    // basic no mochi bg
    init(backgroundColor : UIColor, mochiForeground : UIColor) {
        updateScreenScales() // !!
        super.init(frame : CGRect(x: 0.0, y: 0.0, width: sW, height: sH));
        self.backgroundColor = backgroundColor;
        self.clipsToBounds = true
        self.foregroundColors = [mochiForeground]
        setUpRows()
    }
    
    init(backgroundColor : UIColor, mochiForeground : UIColor, mochiBackground : UIColor) {
        updateScreenScales() // !!
        super.init(frame : CGRect(x: 0.0, y: 0.0, width: sW, height: sH));
        self.backgroundColor = backgroundColor;
        self.clipsToBounds = true
        self.foregroundColors = [mochiForeground]
        self.mochiBackgroundColors = [mochiBackground]
        setUpRows()
    }
    
    init(backgroundColor : UIColor, mochiForeground : [UIColor], mochiBackground : [UIColor]) {
        updateScreenScales() // !!
        super.init(frame : CGRect(x: 0.0, y: 0.0, width: sW, height: sH));
        self.backgroundColor = backgroundColor;
        self.clipsToBounds = true
        self.foregroundColors = mochiForeground
        self.mochiBackgroundColors = mochiBackground
        setUpRows()
    }
    
    func createAnimation() {
        for case let row as rowClass in self.subviews {
            row.createAnimation()
        }
    }
    
    func removeAnimation() {
        for case let row as rowClass in self.subviews {
            row.removeAnimation()
        }
    }
    
    func setUpRows() {
        let _h = sHR * rowMaxHeight / 2048
        var _g = sHR * gapVertical / 2048
        let _num = sH / (_h + _g)
        let num = _num.rounded()
        let h = sH / num
        _g = sHR * gapHorizontal / 2048
        for i in 0..<Int(num) {
            let row = rowClass(frame: CGRect(x: 0.0, y: 0.0, width: sW, height: h))
            row.center.y = (CGFloat(i) + 0.5) * h
            
            row.createRow(self.foregroundColors, self.mochiBackgroundColors, _h, _g, h, (i % 2 == 0 ? 1.0 : -1.0))
            
            self.addSubview(row)
        }
    }
}
class rowClass: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        NotificationCenter.default.addObserver(self, selector: #selector(createAnimation), name:
            UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    let totalAnimTime = 2.0
    let allowRandomSpeeds : Bool = false
    let maxExtraTime = 16.0
    let numExtra : Int = 2
    var xOff : CGFloat = 0.0
    var centerX : CGFloat = 0.0
    var numToUse : Int = 0
    
    func createRow(_ fg : [UIColor], _ height : CGFloat, _ gap : CGFloat, _ pH : CGFloat, _ dir : CGFloat) {
        createRow(fg, [], height, gap, pH, dir)
    }
    
    func createRow(_ fg : [UIColor], _ bg : [UIColor], _ height : CGFloat, _ gap : CGFloat, _ pH : CGFloat, _ dir : CGFloat) {
        let aspect : CGFloat = 884 / 362
        let w = aspect * height
        let num = sW / (w + gap)
        let extra = bg.count == fg.count ? fg.count : fg.count * bg.count
        numToUse = Int(num.rounded()) + numExtra + extra
        let mid : CGFloat = 0.5 * CGFloat(numToUse - 1)
        for i in 0..<numToUse {
            let img = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: w, height: height))
            img.center = CGPoint(x: sW * 0.5 + (CGFloat(i) - mid) * (w + gap), y: 0.5 * pH)
            self.addSubview(img)
            if bg.count == 0 {
                img.image = UIImage(named: "mochi_bordered.png")
                img.tintColor = fg[i % fg.count]
                print("!! - hello?")
                
                continue
            }
            img.image = UIImage(named: "mochi_bordered_bg.png")
            img.tintColor = bg[i % bg.count]
            
            let _img = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: w, height: height))
            img.addSubview(_img)
            _img.image = UIImage(named: "mochi_bordered.png")
            _img.tintColor = fg[i % fg.count]
            
        }
        
        xOff = sW * 0.5 + CGFloat(extra == 0 ? 1 : extra) * (w + gap) * dir
        self.centerX = self.center.x
        createAnimation()
    }
    
    @objc func createAnimation() {
        self.center.x = self.centerX
        let time = 20.0 * Double(self.numToUse / 5)
        UIView.animate(withDuration: time, delay: 0.0, options: [.curveLinear, .repeat], animations: {
            self.center.x = self.xOff
        }) { (_) in
            //
        }
    }
    @objc func removeAnimation() {
        self.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }
}
