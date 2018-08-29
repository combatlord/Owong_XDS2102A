//
//  ChannelView.swift
//  OwongBinFile
//
//  Created by Friedrich HAEUPL on 22.08.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

/// Class which encapsulates a Swift byte array (an Array object with elements of type UInt8) and an
/// index into the array.
open class ByteArrayAndIndex {
    
    private var _byteArray : [UInt8]
    private var _arrayIndex = 0
    
    public init(_ byteArray : [UInt8]) {
        _byteArray = byteArray;
    }
    
    /// Property to provide read-only access to the current array index value.
    public var arrayIndex : Int {
        get { return _arrayIndex }
    }
    
    /// Property to calculate how many bytes are left in the byte array, i.e., from the index point
    /// to the end of the byte array.
    public var bytesLeft : Int {
        get { return _byteArray.count - _arrayIndex }
    }
    
    /// Method to get a single byte from the byte array.
    public func getUInt8() -> UInt8 {
        let returnValue = _byteArray[_arrayIndex]
        _arrayIndex += 1
        return returnValue
    }
    
    //
    /* Method to get an Int16 from two bytes in the byte array (little-endian).
     public func getInt16() -> Int16 {
     return Int16(bitPattern: getUInt16())
     }
     */
    
    public func getInt16() -> Int16 {
        let returnValue = Int16(_byteArray[_arrayIndex]) | Int16(_byteArray[_arrayIndex + 1]) << 8
        _arrayIndex += 2
        return returnValue
    }
    /// Method to get a UInt16 from two bytes in the byte array (little-endian).
    public func getUInt16() -> UInt16 {
        let returnValue = UInt16(_byteArray[_arrayIndex]) |
            UInt16(_byteArray[_arrayIndex + 1]) << 8
        _arrayIndex += 2
        return returnValue
    }
    
    /// Method to get a UInt from three bytes in the byte array (little-endian).
    public func getUInt24() -> UInt {
        let returnValue = UInt(_byteArray[_arrayIndex]) |
            UInt(_byteArray[_arrayIndex + 1]) << 8 |
            UInt(_byteArray[_arrayIndex + 2]) << 16
        _arrayIndex += 3
        return returnValue
    }
    
    /// Method to get an Int32 from four bytes in the byte array (little-endian).
    public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    /// Method to get a UInt32 from four bytes in the byte array (little-endian).
    public func getUInt32() -> UInt32 {
        let returnValue = UInt32(_byteArray[_arrayIndex]) |
            UInt32(_byteArray[_arrayIndex + 1]) << 8 |
            UInt32(_byteArray[_arrayIndex + 2]) << 16 |
            UInt32(_byteArray[_arrayIndex + 3]) << 24
        _arrayIndex += 4
        return returnValue
    }
    
}

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
    
    func drawGrid()
    {//  grid points
        let GRID_STEP = 100
        
        let gridColor = NSColor.lightGray.withAlphaComponent(0.6)
        gridColor.set() // choose color
        
        let path:NSBezierPath = NSBezierPath()
        
        for i in 1..<100 {
            for j in 1..<50 {
                
                // TRACK_RADIUS
                let x_pos = CGFloat(i * GRID_STEP)
                let y_pos = CGFloat(j * GRID_STEP)
                
                path.removeAllPoints()
                path.move(to: NSMakePoint(x_pos - 5,y_pos))
                path.line(to: NSMakePoint(x_pos + 5,y_pos))
                path.move(to: NSMakePoint(x_pos ,y_pos - 5))
                path.line(to: NSMakePoint(x_pos ,y_pos + 5))
                path.lineWidth = 1
                
                path.stroke()
                
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        NSColor(red: 28.0/255.0, green: 60.0/255.0, blue: 121.0/255.0, alpha: 1.0).set()
        NSBezierPath.fill(dirtyRect)
        
        drawGrid()
        
        // let fillcolor = NSColor.init(deviceRed: 152.0/255.0, green: 180.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        let stroke1Color = NSColor.white.withAlphaComponent(0.6)
        let stroke2Color = NSColor.yellow.withAlphaComponent(0.6)
        
        // first graph
        stroke1Color.set() // choose color
        let ch1 = NSBezierPath() // container for line(s)
        ch1.lineWidth = 1  // hair line
        
        
        let ch1ByteArray:ByteArrayAndIndex = ByteArrayAndIndex(ch1_values)
        var actual_value = ch1ByteArray.getInt16()
        
        ch1.move(to: NSMakePoint(0, 2500 + CGFloat(actual_value))) // start point
        
        if (ch1_cnt > 0) {
            for i in 0 ..< ch1_cnt/2 - 1 {
                actual_value = ch1ByteArray.getInt16()
                ch1.line(to: NSMakePoint(CGFloat(i), 2500 + CGFloat(actual_value))) // destination
            }
        }
        ch1.stroke()  // draw line(s) in color
        

        let ch2ByteArray:ByteArrayAndIndex = ByteArrayAndIndex(ch2_values)
        actual_value = ch2ByteArray.getInt16()
        
        stroke2Color.set() // choose color
        let ch2 = NSBezierPath() // container for line(s)
        ch2.lineWidth = 1  // hair line

        ch2.move(to: NSMakePoint(0, 2500 + CGFloat(actual_value))) // start point
        
        if (ch2_cnt > 0) {
            for i in 0 ..< ch2_cnt/2 - 1 {
                actual_value = ch2ByteArray.getInt16()
                ch2.line(to: NSMakePoint(CGFloat(i), 2500 + CGFloat(actual_value))) // destination
            }
        }
        ch2.stroke()  // draw line(s) in color
        
    }
    
}
