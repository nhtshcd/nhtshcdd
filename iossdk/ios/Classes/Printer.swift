//
//  Printer.swift
//  Runner
//
//  Created by faranegar on 6/21/20.
//

import Foundation

class Printer{

    let connectedStr:String = "Connected"
    let disconnectedStr:String = "Disconnected"
    let disconnectingStr:String = "Disconnecting"
    let connectingStr:String = "Connecting"
    let sendingDataStr:String = "Sending Data"
    
    let disconnectedColor = "R"
    let connectedColor = "G"
    let connectingColor = "Y"
    
    let doneStr:String = "Done"
    var connection : ZebraPrinterConnection?
    var methodChannel : FlutterMethodChannel?
    var selectedIPAddress: String? = nil
    var selectedMacAddress: String? = nil
    var isZebraPrinter :Bool = true
    var wifiManager: POSWIFIManager?
    var isConnecting :Bool = false
    
    static func getInstance(binaryMessenger : FlutterBinaryMessenger) -> Printer {
        let printer = Printer()
        printer.setMethodChannel(binaryMessenger: binaryMessenger)
        return printer
    }

    //Send dummy to get user permission for local network
    func dummyConnect(){
        var connection = TcpPrinterConnection(address: "0.0.0.0", andWithPort: 9100)
        connection?.open()
        connection?.close()
    }

    func discoveryPrinters(){
      dummyConnect()
      print("Message from ios: starting for discovering printers")
      let manager = EAAccessoryManager.shared()
        
      let devices = manager.connectedAccessories
      for d in devices {
        print("Message from ios: orinter found")
        let data: [String: Any] = [
            "Name": d.name,
            "Address": d.serialNumber,
             "IsWifi": false
              ]
        self.methodChannel?.invokeMethod("printerFound", arguments: data)
      }
        self.methodChannel?.invokeMethod("onPrinterDiscoveryDone", arguments: nil)
    }
    
    func setMethodChannel(binaryMessenger : FlutterBinaryMessenger) {
        self.methodChannel = FlutterMethodChannel(name: "ZebraPrinterObject" + toString(), binaryMessenger: binaryMessenger)
        self.methodChannel?.setMethodCallHandler({ (FlutterMethodCall,  FlutterResult) in
            let args = FlutterMethodCall.arguments
            let myArgs = args as? [String: Any]
            if(FlutterMethodCall.method == "print"){
                self.printData(data: myArgs?["Data"] as! NSString)
            }else if(FlutterMethodCall.method == "printImage"){
                self.printImage(data: myArgs?["Data"] as! NSString, image:  myArgs?["Image"] as! NSString)
            }
            else if(FlutterMethodCall.method == "checkPermission"){
                FlutterResult(true)
            } else if(FlutterMethodCall.method == "disconnect"){
                DispatchQueue.global(qos: .utility).async {
                    self.disconnect()
                          }
            } else if(FlutterMethodCall.method == "isPrinterConnected") {
                     FlutterResult(self.isPrinterConnect())
            } else if(FlutterMethodCall.method == "discoverPrinters") {
                self.discoveryPrinters()
            } else if(FlutterMethodCall.method == "setSettings") {
                let settingCommand = myArgs?["SettingCommand"] as? NSString
                        self.setSettings(settings: settingCommand!)
            } else if(FlutterMethodCall.method == "connectToPrinter" || FlutterMethodCall.method == "connectToGenericPrinter" ) {
                   let address = myArgs?["Address"] as? String
                DispatchQueue.global(qos: .utility).async { self.connectToSelectPrinter(address: address!)
                             }
            }
        })
    }

    func toString() -> String{
        return String(UInt(bitPattern: ObjectIdentifier(self)))
    }
    
    func connectToGenericPrinter(address: String) {
        self.isZebraPrinter = false
           setStatus(message: connectingStr, color:connectingColor)
        if self.wifiManager != nil{
            self.wifiManager?.posDisConnect()
                 setStatus(message: disconnectedStr, color: disconnectedColor)
                 setStatus(message: connectingStr, color: connectingColor)
        }
        self.wifiManager = POSWIFIManager()
        self.wifiManager?.posConnect(withHost: address, port: 9100, completion: { (result) in
            if result == true {
                self.setStatus(message: self.connectedStr, color: self.connectedColor)
            } else {
                self.setStatus(message: self.disconnectedStr, color: self.disconnectedColor)
            }
        })  
    }
    
    func connectToSelectPrinter(address: String) -> Bool{
        if(self.isConnecting == false) {
            self.isConnecting = true
            self.isZebraPrinter = true
            selectedIPAddress = nil
            setStatus(message: connectingStr, color:connectingColor)
            if(self.connection != nil){
                self.connection?.close()
                setStatus(message: disconnectedStr, color: disconnectedColor)
                setStatus(message: connectingStr, color: connectingColor)
            }
            if(!address.contains(".")){
                self.connection = MfiBtPrinterConnection(serialNumber: address)

            }else {
               self.connection = TcpPrinterConnection(address: address, andWithPort: 9100)
            }
            Thread.sleep(forTimeInterval: 1)
            let isOpen = self.connection?.open()
                 print("connection open ")
            self.isConnecting = false
            if isOpen == true {
                Thread.sleep(forTimeInterval: 1)
                self.selectedIPAddress = address
                setStatus(message: connectedStr, color: connectedColor)
                return true
            } else {
                setStatus(message: disconnectedStr, color: disconnectedColor)
                return false
            }
        }
        else  {
            return false
        }
    }

    func isPrinterConnect() -> String{
        if self.isZebraPrinter == true {
        if self.connection?.isConnected() == true {
            setStatus(message: connectedStr, color: connectedColor)
              return connectedStr
        }
        else {
            setStatus(message: disconnectedStr, color: disconnectedColor)
              return disconnectedStr
        }
        } else {
            if(self.wifiManager?.connectOK == true){
                setStatus(message: connectedStr, color: connectedColor)
                return connectedStr
            } else {
                setStatus(message: disconnectedStr, color: disconnectedColor)
                        return disconnectedStr
            }
        }
    }

    func setSettings(settings: NSString){
        printData(data: settings)
    }

    func disconnect() {
        if self.isZebraPrinter == true {
            setStatus(message: disconnectingStr, color: connectingColor)
            if self.connection != nil {
                self.connection?.close()
            }
            setStatus(message: disconnectedStr, color: disconnectedColor)
        } else {
               setStatus(message: disconnectingStr, color: connectingColor)
            if self.wifiManager != nil{
                self.wifiManager?.posDisConnect()
            }
           setStatus(message: disconnectedStr, color: disconnectedColor)
        }
    }

   func printData(data: NSString) {
    //ToDo improve sending data
     DispatchQueue.global(qos: .utility).async {
      let dataBytes = Data(bytes: data.utf8String!, count: data.length)
      DispatchQueue.main.async {
        self.setStatus(message: "Sending Data", color: self.connectingColor)
             }
        if self.isZebraPrinter == true {
              var error: NSError?
              let result = self.connection?.write(dataBytes, error: &error)
              if result == -1, let error = error {
                print(error)
                self.disconnect()
                return
              }
        } else {
            self.wifiManager?.posWriteCommand(with: dataBytes, withResponse: { (result) in
                
            })
        }
      sleep(1)
        DispatchQueue.main.async {
            self.setStatus(message: self.doneStr, color: self.connectedColor)
        }
     }
    }
    
    func printImage(data: NSString,image: NSString) {
     //ToDo improve sending data
      DispatchQueue.global(qos: .utility).async {
       let dataBytes = Data(bytes: data.utf8String!, count: data.length)
          
         
          //for CPCL Programming college
         // let decodedimage:UIImage  = self.imageFromBase64(base64image as String)
       DispatchQueue.main.async {
         self.setStatus(message: "Sending Data ", color: self.connectingColor)
              }
         
         
         if self.isZebraPrinter == true {
            
               var error: NSError?
               let result = self.connection?.write(dataBytes, error: &error)
               if result == -1, let error = error {
                 print(error)
                 self.disconnect()
                 return
               }
             
         } else {
             self.wifiManager?.posWriteCommand(with: dataBytes, withResponse: { (result) in
                 
             })
         }
          
          //let imagedata = Data(base64Encoded: image as String, options: .ignoreUnknownCharacters)
          let imagedata = self.imageFromBase64(base64:image as String);
          let cpclconverted = self.ExtractGraphicsDataForCPCL(bmpimage:imagedata )
          //let cpclcode = "! 0 200 200 210 1\r\nEG 40 80 0 0\n" + cpclconverted+"\n\nPRINT\r\n";
          let cpclcode = "! 100 40 350 350 1\r\nEG 38 300 0 0 \n" + cpclconverted+"\n\nPRINT\r\n";
          print("CPCL code \(cpclcode)")

          let imageprintdata = Data(bytes: NSString(string:cpclcode).utf8String!, count: NSString(string:cpclcode).length)
          DispatchQueue.main.async {
            self.setStatus(message: "Sending Image Data ", color: self.connectingColor)
                 }
            
            
            if self.isZebraPrinter == true {
               
                  var error: NSError?
                  let result = self.connection?.write(imageprintdata, error: &error)
                  if result == -1, let error = error {
                    print(error)
                    self.disconnect()
                    return
                  }
                
            } else {
                self.wifiManager?.posWriteCommand(with: imageprintdata, withResponse: { (result) in
                    
                })
            }
          
       sleep(1)
         DispatchQueue.main.async {
             self.setStatus(message: self.doneStr, color: self.connectedColor)
         }
      }
     }
    func ExtractGraphicsDataForCPCL(bmpimage: UIImage) -> String{
     //ToDo improve sending data
        var m_data="";
        var color=(r: 0, g: 0, b: 0, a: 0);
        var bit=0;
        var currentValue=0;
        var redValue=0;
        var blueValue=0;
        var greenValue=0;
        do {
            var loopWidth = 8 - (bmpimage.size.width.truncatingRemainder(dividingBy: 8))
            if (loopWidth == 8){
                loopWidth = bmpimage.size.width
            }
            else{
                loopWidth += bmpimage.size.width
            }
        
            m_data.appending("EG ")
            m_data.appending(String(loopWidth / 8))
            m_data.appending(" ")
            m_data.appending("\(bmpimage.size.height)")
            m_data.appending(" ")
            m_data.appending("0 ")
            m_data.appending("0 ")
            for y in (0 ..< Int(roundf(Float(bmpimage.size.height)))) {
                bit = 128;
                currentValue = 0;
                for x in (0 ..< Int(roundf(Float(loopWidth)))) {
                    var intensity=0;
                    if (x < Int(roundf(Float(bmpimage.size.width))))
                                      {
                        color = (bmpimage.cgImage?.pixel(x: x, y: y))!

                        redValue = color.r;
                                          blueValue = color.b;
                                          greenValue = color.g;

                                          intensity = 255 - ((redValue + greenValue + blueValue) / 3);
                    }else{
                        intensity = 0;
                    }
                    
                    if (intensity >= 128){
                        currentValue |= bit;
                    }
                    
                    
                    bit = bit >> 1;
                    if (bit == 0)
                    {
                       // var hex = String(format:"%02x", currentValue)
                        var hex = String(currentValue).decimalToHexa;
                        hex = LeftPad(_num: hex) ;
                        m_data.append(hex.uppercased());
                        bit = 128;
                        currentValue = 0;

                        /*
                         String dbg = "x,y" + "-"+ Integer.toString(x) + "," + Integer.toString(y) + "-" +
                         "Col:" + Integer.toString(color) + "-" +
                         "Red: " +  Integer.toString(redValue) + "-" +
                         "Blue: " +  Integer.toString(blueValue) + "-" +
                         "Green: " +  Integer.toString(greenValue) + "-" +
                         "Hex: " + hex;

                         Log.d(TAG,dbg);
                         */

                    }
                    
                }
            }
            m_data.append("\r\n");
          } catch let error as Error {
              return m_data;
          }
        return m_data;
     }
    func LeftPad(_num: String) -> String{
        var str = _num;

              if (_num.count == 1)
              {
                  str = "0" + _num;
              }

              return str;
    }
//    func imageFromBase64(base64: String) -> UIImage? {
//        if let url = URL(string: base64), let data = try? Data(contentsOf: url) {
//            return UIImage(data: data)
//        }
//        return nil
//    }
    
    func imageFromBase64 (base64:String) -> UIImage {
        let imageData = Data(base64Encoded: base64)
        let image = UIImage(data: imageData!)
        return image!
    }
    func setStatus(message: String, color: String){
        let data: [String: Any] = [
            "Status": message,
            "Color": color
        ]
        self.methodChannel?.invokeMethod("changePrinterStatus", arguments: data)

    }

}
extension CGImage {
    func pixel(x: Int, y: Int) -> (r: Int, g: Int, b: Int, a: Int)? { // swiftlint:disable:this large_tuple
        guard let pixelData = dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData) else { return nil }

        let pixelInfo = ((width  * y) + x ) * 4

        let red = Int(data[pixelInfo])         // If you need this info, enable it
        let green = Int(data[(pixelInfo + 1)]) // If you need this info, enable it
        let blue = Int(data[pixelInfo + 2])    // If you need this info, enable it
        let alpha = Int(data[pixelInfo + 3])   // I need only this info for my maze game

        return (red, green, blue, alpha)
    }
}
extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hexaToDecimal: Int { Int(dropping(prefix: "0x"), radix: 16) ?? 0 }
    var hexaToBinary: String { .init(hexaToDecimal, radix: 2) }
    var decimalToHexa: String { .init(Int(self) ?? 0, radix: 16) }
    var decimalToBinary: String { .init(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal: Int { Int(dropping(prefix: "0b"), radix: 2) ?? 0 }
    var binaryToHexa: String { .init(binaryToDecimal, radix: 16) }
}
