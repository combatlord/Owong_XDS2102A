//
//  ViewController.swift
//  OwongBinFile
//
//  Created by Friedrich HAEUPL on 22.08.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

struct Waveform: Decodable {
    var MODEL : String
    var IDN : String
    var channel: [Channel]
}

struct Channel: Decodable {
    var Index: String
    var Availability_Flag: String
    var Display_Switch: String
    var Wave_Character: String
    var Sample_Rate: String
    var Acqu_Mode: String
    var Storage_Depth: String
    var Display_Mode: String
    var Hscale: String
    var Vscale: String
    var Reference_Zero: String
    var Scroll_Pos_Time: String
    var Trig_After_Time: String
    var Trig_Tops_Tme: String
    var Adc_Data_Time: String
    var Adc_Data0_Time: String
    var Voltage_Rate: String
    var Data_Length: String
    var Probe_Magnification: String
    var Current_Rate: Float
    var Current_Ratio: Float
    var Measure_Current_Switch: String
    var Cyc: String
    var Freq: String
    var PRECISION: Int
}

// there are already connections setup in IB for openDocument/saveDocument/newDocumnet
// http://stackoverflow.com/questions/28008262/detailed-instruction-on-use-of-nsopenpanel

extension NSOpenPanel {
    var selectUrl: URL? {
        title = "Select File"
        allowsMultipleSelection = false
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        //allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]
        // to allow only images, just comment out this line to allow any file type to be selected
        allowedFileTypes = ["bin","BIN"]
        return runModal() == NSApplication.ModalResponse.OK ? urls.first : nil
    }
}



func bytesToHexa(_ bytes: [UInt8]) -> String {
    return bytes.map{ String(format: "%02X ", $0) }.joined()
}



class ViewController: NSViewController {
    
    @IBOutlet weak var channelViewOutlet: ChannelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func OpenOsziFileAction(_ sender: Any) {
        
        print("OpenOsziFileAction")
        
        // http://stackoverflow.com/questions/30093688/how-to-create-range-in-swift
        // http://stackoverflow.com/questions/39655472/nsdata-to-data-swift-3
        
        // let header_range: Range = 0..<32
        
        var second_channel_available = false
        if let url = NSOpenPanel().selectUrl {
            
            print("file selected  = \(url.path)")
            print("filename       = \(url.lastPathComponent)")
            print("pathExtension  = \(url.pathExtension)")
            
            let data = NSData(contentsOf: url as URL) as Data?  // <==== Added 'as Data?'
            if let data = data {                                // <==== Added 'if let'
                print("data           = \(data)")
                
                // calculate the expected header size and datasize
                let headersize = data.count % 10000
                let datasize = data.count / 10000
                print("headersize     = \(headersize)")
                print("datasize       = \(datasize)")
                
                // create array of appropriate length:
                var header = [UInt8](repeating: 0, count: 10)
                // copy bytes into array
                data.copyBytes(to: &header, count: 10)
                print("header hex     = \(bytesToHexa(header))")
                
                let jsonlength:Int = Int(header[6]) + Int(header[7]) << 8 + Int(header[8]) << 16 + Int(header[9]) << 24
                print("jsonlength     = \(jsonlength)")
                
                // Get a new copy of data
                let dataRange =  Range(10..<jsonlength+10)
                let jsonheaderdata:Data = data.subdata(in: dataRange)
                // parse JSON
                do {
                    let waveformDescription = try JSONDecoder().decode(Waveform.self, from: jsonheaderdata)
                    
                    print (waveformDescription.MODEL)
                    print (waveformDescription.IDN)
                    
                    for ch in waveformDescription.channel {
                        print (ch.Index)
                        print (ch.Sample_Rate)
                        print (ch.Storage_Depth)
                        print (ch.Hscale)
                        print (ch.Vscale)
                        print (ch.Voltage_Rate)
                        print (ch.Data_Length)
                    }
                    if waveformDescription.channel.count == 2{
                        second_channel_available = true
                    }
                }
                catch {
                    print("error:\(error)")
                }
                
                
                // Get a new copy of data
                var channelRange =  Range(jsonlength+10..<20000+10)
                var channeldata:Data = data.subdata(in: channelRange)
                // create array of appropriate length:
                var channel1Array = [UInt8](repeating: 0, count: 20000)
                channeldata.copyBytes(to: &channel1Array, count: 20000)
                
                var channel2Array = [UInt8](repeating: 0, count: 20000)
                if second_channel_available == true {
                    channelRange = Range(jsonlength + 10 + 20000..<jsonlength + 10 + 40000)
                    channeldata = data.subdata(in: channelRange)
                    // create array of appropriate length:
                    channeldata.copyBytes(to: &channel2Array, count: 20000)
                }
                /*
                 var channel1_values = [Int16](repeating: 0, count: 10000)
                 var channel2_values = [Int16](repeating: 0, count: 10000)
                 
                 for i in 0..<10000 {
                 channel1_values[i] = Int16(channelArray[2*i + 1]) + 256 * Int16(channelArray[2*i])
                 }
                 */
                
                // https://stackoverflow.com/questions/37204073/how-to-pass-value-from-nsviewcontroller-to-custom-nsview-of-nspopover
                if second_channel_available == true {
                    channelViewOutlet.addChannels(20000, channel1Array, 20000, channel2Array)
                }
                else
                {
                    channelViewOutlet.addChannels(20000, channel1Array, 0, channel2Array)
                }
                
                
            }
        }
    }
}

