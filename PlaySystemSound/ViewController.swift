//
//  ViewController.swift
//  PlaySystemSound
//
//  Created by hideji on 2015/01/06.
//  Copyright (c) 2015年 hideji. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    var functionPointer: AudioServicesCompletionFunctionPointer?
    var soundCounter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var soundIdRing:SystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
        let soundUrl = NSURL(fileURLWithPath: "/System/Library/Audio/UISounds/new-mail.caf")
        AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
        
        
        let block = { [unowned self] (systemSoundID: SystemSoundID, userData: UnsafeMutablePointer<Void>) -> () in
            (self.soundCounter)--
            if self.soundCounter > 0 {
                NSThread.sleepForTimeInterval(0.5)
                AudioServicesPlaySystemSound(soundIdRing);
            } else {
                AudioServicesRemoveSystemSoundCompletion(soundIdRing);
            }
        }
        

        var vself = self
        let userData = withUnsafePointer(&vself, {
            (ptr: UnsafePointer<ViewController>) -> UnsafeMutablePointer<Void> in
            return unsafeBitCast(ptr, UnsafeMutablePointer<Void>.self)
        })
        
        self.functionPointer = AudioServicesCompletionFunctionPointer(systemSoundID: soundIdRing, block: block, userData: userData)
        AudioServicesAddSystemSoundCompletion(soundIdRing, CFRunLoopGetMain(), kCFRunLoopCommonModes, AudioServicesCompletionFunctionPointer.completionHandler(), userData)
        
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

