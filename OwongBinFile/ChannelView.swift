//
//  ChannelView.swift
//  OwongBinFile
//
//  Created by Friedrich HAEUPL on 22.08.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

class ChannelView: NSView {
    
    var ch1_values = [UInt8](repeating: 0, count: 20000)
    var ch1_cnt = 0
    var ch2_values = [UInt8](repeating: 0, count: 20000)
    var ch2_cnt = 0
   
    // https://stackoverflow.com/questions/37204073/how-to-pass-value-from-nsviewcontroller-to-custom-nsview-of-nspopover
    //
    func addChannels(_ channel1_cnt:Int, _ channel1_values:[UInt8], _ channel2_cnt:Int, _ channel2_values:[UInt8])
    {
        ch1_values = channel1_values
        ch1_cnt = channel1_cnt
        ch2_values = channel2_values
        ch2_cnt = channel2_cnt
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //var i = 0

        // Drawing code here.
        NSColor(red: 28.0/255.0, green: 60.0/255.0, blue: 121.0/255.0, alpha: 1.0).set()
        NSBezierPath.fill(dirtyRect)
        
        // let fillcolor = NSColor.init(deviceRed: 152.0/255.0, green: 180.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        let stroke1Color = NSColor.white.withAlphaComponent(0.6)
        let stroke2Color = NSColor.yellow.withAlphaComponent(0.6)
        
        // first graph
        stroke1Color.set() // choose color
        let ch1 = NSBezierPath() // container for line(s)
        ch1.lineWidth = 1  // hair line
    
        var actual_value = Int(ch1_values[0])  + 256 * Int(ch1_values[1])

        ch1.move(to: NSMakePoint(0, 0.05 * CGFloat(actual_value))) // start point

        for i in 0 ..< ch1_cnt/2 {
            actual_value = Int(ch1_values[2 * i]) + 256 * Int(ch1_values[2 * i + 1])
            ch1.line(to: NSMakePoint(CGFloat(i), 0.05 * CGFloat(actual_value))) // destination
        }
        ch1.stroke()  // draw line(s) in color
        
        // second graph
        stroke2Color.set() // choose color
        let ch2 = NSBezierPath() // container for line(s)
        ch2.lineWidth = 1  // hair line
        
        actual_value = Int(ch2_values[0]) + 256 * Int(ch2_values[1])
        
        ch2.move(to: NSMakePoint(0, 0.05 * CGFloat(actual_value))) // start point
        
        for i in 0 ..< ch2_cnt/2 {
            actual_value = Int(ch2_values[2*i]) + 256 * Int(ch2_values[2*i + 1])
            ch2.line(to: NSMakePoint(CGFloat(i), 0.05 * CGFloat(actual_value))) // destination
        }
        
        ch2.stroke()  // draw line(s) in color
    }
    
}
