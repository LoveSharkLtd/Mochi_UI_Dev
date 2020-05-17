//
//  ProgressBar.swift
//  Mochi
//
//  Created by Sam Weekes on 5/17/20.
//  Copyright © 2020 Sam Weekes. All rights reserved.
//

import Foundation
import UIKit


class ProgressBar : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numChallenges = 0
    var completed = 0 {
        didSet {
            self.updateProgress()
        }
    }
    
    var progressUI : UIView?
    var progressGlow : UIView?
    var thumbGlow : UIView?
    var thumbUI : UIView?
    
    var maxWidth : CGFloat = 0.0
    
    init(width : CGFloat, segments : Int, color : UIColor) {
        let width = width
        let height = sHR * 17 / 667
        
        let gap = sHR * 2 / 667

        
        maxWidth = width
        
        let w = (width - CGFloat(segments - 1) * gap) / CGFloat(segments) // width of segments
        let h = sHR * 7 / 667
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        
        numChallenges = segments
        
        for i in 0..<numChallenges {
            let bg = UIView(frame: CGRect(x: CGFloat(i) * (w + gap), y: 0.0, width: w, height: h))
            bg.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
            bg.center.y = height * 0.5
            if (i == 0 || i == numChallenges - 1) {
                bg.layer.cornerRadius = h * 0.5
                bg.layer.maskedCorners = i == 0 ? [.layerMinXMinYCorner, .layerMinXMaxYCorner] : [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
            self.addSubview(bg)
        }
        
        progressGlow = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: h))
        progressGlow?.backgroundColor = color
        progressGlow?.glow(color: color, size : 5.0)
        progressGlow?.layer.cornerRadius = h * 0.5
        progressGlow?.center.y = height * 0.5
        self.addSubview(progressGlow!)
        
        progressUI = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: h))
        progressUI?.backgroundColor = color
        progressUI?.layer.cornerRadius = h * 0.5
        progressUI?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        progressUI?.clipsToBounds = true
        progressUI?.applyGradient(colours: [color, color.desaturateAndBrighten(saturation: 0.15, brightness: 1.0), color])
        progressUI?.center.y = height * 0.5
        self.addSubview(progressUI!)
        
        thumbGlow = UIView(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 14 / 667, height: sHR * 33 / 667)) //sHR * 33 / 667))
        thumbGlow?.layer.cornerRadius = sHR * 2 / 667
//        thumbGlow?.backgroundColor = pink
//        thumbGlow?.glow(color: pink, size: 2)
        thumbGlow?.applyGradientRadial(colours: [color.withAlphaComponent(0.5), color.withAlphaComponent(0.0)])
        thumbGlow?.clipsToBounds = true
        thumbGlow?.center = CGPoint(x: 0.0, y: height * 0.5)
//        self.addSubview(thumbGlow!)
        
        thumbUI = UIView(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 4 / 667, height: height))
        thumbUI?.backgroundColor = color
        thumbUI?.layer.cornerRadius = sHR * 2 / 667
        thumbUI?.applyGradientHorizontal(colours: [color, UIColor.white, color])
        thumbUI?.clipsToBounds = true
        thumbUI?.center = CGPoint(x: 0.0, y: height * 0.5)
        
        self.addSubview(thumbUI!)
        updateProgress()
    }
    
    func updateProgress() {
        let end = self.maxWidth * CGFloat(completed) / CGFloat(numChallenges)
        UIView.animate(withDuration: 0.125, delay: 0.0, options: .curveEaseOut, animations: {
            self.progressUI?.frame.size.width = end
            self.progressGlow?.frame.size.width = end
            self.thumbUI?.center.x = end
            self.thumbGlow?.center.x = end
        }) { (_) in
            //
        }
    }
    
}
