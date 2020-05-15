//
//  Adb+Screencap.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import os
import Foundation
import Cocoa

extension Adb {
    
    public static func screencap(destinationPath: URL? = nil, needsCleanUp: Bool = true) -> Result<URL, Adb.Error> {
        let uuid = UUID().uuidString
        
        let log = OSLog.adb
        let spid = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: "screencap", signpostID: spid, "%s", uuid)
        defer {
            os_signpost(.end, log: log, name: "screencap", signpostID: spid)
        }
        
        let filename = "\(uuid).png"
        let filepath = "/storage/emulated/0/Pictures/\(filename)"
        
        guard let destinationDirctory = destinationPath ?? (try? applicationScreencapDirectory()) else {
            return .failure(.screencap(message: "cannot create screencap dirctory"))
        }
        let destinationURL = destinationDirctory.appendingPathComponent(filename)
        let destinationPath = destinationURL.path
        
        // 1. take screenshot
        os_signpost(.begin, log: log, name: "screencap - snap", signpostID: spid, "before take screenshot")
        let screencapResult = adb(arguments: ["shell", "screencap", filepath])
        os_signpost(.end, log: log, name: "screencap - snap", signpostID: spid, "after take screenshot")
        
        // 2. pull screenshot from device
        os_signpost(.begin, log: log, name: "screencap - pull", signpostID: spid, "before pull")
        let pullResult = screencapResult.flatMap { _ -> Result<String, Adb.Error> in
            do {
                try FileManager.default.createDirectory(at: destinationDirctory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return .failure(.screencap(message: error.localizedDescription))
            }
            
            return adb(arguments: ["pull", filepath, destinationPath])
        }
        os_signpost(.end, log: log, name: "screencap - pull", signpostID: spid, "after pull")
        
        // 3. remove screenshot on device
        if needsCleanUp {
            os_signpost(.begin, log: log, name: "screencap - cleanup", signpostID: spid, "before cleanup")
            let removeResult = pullResult.flatMap { _ -> Result<String, Adb.Error> in
                return adb(arguments: ["shell", "rm", filepath])
            }
            os_signpost(.end, log: log, name: "screencap - cleanup", signpostID: spid, "after cleanup")
            return removeResult.map { _ in destinationURL }
        } else {
            return pullResult.map { _ in destinationURL }
        }
    }
    
    
    // Ref: https://stackoverflow.com/questions/13578416/read-binary-stdout-data-from-adb-shell
    public static func screencapDirect() -> Result<NSImage, Adb.Error> {
        let log = OSLog.adb
        let spid = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: "screencap direct - snap", signpostID: spid, "before take screenshot")
        
        #if DEBUG
        let start = CFAbsoluteTimeGetCurrent()
        #endif
        
        let screencapResult = Adb.adbData(arguments: ["exec-out", "screencap"])
        
        #if DEBUG
        let diff = CFAbsoluteTimeGetCurrent() - start
        os_log(.debug, log: .adb, "%{public}s[%{public}ld], %{public}s: snapshot tok %{public}s seconds", ((#file as NSString).lastPathComponent), #line, #function, String(describing: diff))
        #endif
        
        os_signpost(.end, log: log, name: "screencap direct - snap", signpostID: spid, "after take screenshot")
        let result = screencapResult.flatMap { imageData -> Result<NSImage, Adb.Error> in
            return Adb.parseRawImage(from: imageData)
        }
        
        return result
    }
    
}

extension Adb {
    
    private static func applicationSupportDocumentDirectory() throws -> URL {
        let applicationSupportFolderURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let folderName = Bundle.main.bundleIdentifier ?? "com.mainasuk.AdbAutomator"
        let documentDirectory = applicationSupportFolderURL.appendingPathComponent(folderName, isDirectory: true)
        
        return documentDirectory
    }
    
    private static func applicationScreencapDirectory() throws -> URL {
        return try applicationSupportDocumentDirectory().appendingPathComponent("screencap", isDirectory: true)
    }
    
}

extension Adb {
    
    // Ref: https://github.com/aosp-mirror/platform_system_core/blob/46f281edf5e78a51c5c1765460cddcf805e88d48/adb/daemon/framebuffer_service.cpp#L88-L91
    static func parseRawImage(from data: Data) -> Result<NSImage, Adb.Error> {
        let width: Int32 = data.withUnsafeBytes { pointer -> Int32 in
            return pointer.load(as: Int32.self)
        }
        let height: Int32 = data.withUnsafeBytes { pointer -> Int32 in
            return pointer.load(fromByteOffset: 4, as: Int32.self)
        }
        let format: Int32 = data.withUnsafeBytes { pointer -> Int32 in
            return pointer.load(fromByteOffset: 8, as: Int32.self)
        }
        
        switch format {
        case 1: // RGBA8888
            let imageContent: NSData = Data(data[12...]) as NSData
            guard let dataProvider: CGDataProvider = CGDataProvider(data: imageContent) else {
                return .failure(Adb.Error.screencap(message: "cannot read image data"))
            }
            
            guard let cgImage = CGImage(
                width: Int(width),
                height: Int(height),
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                bytesPerRow: Int(width) * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                provider: dataProvider,
                decode: nil,
                shouldInterpolate: false,
                intent: .defaultIntent
            ) else {
                return .failure(Adb.Error.screencap(message: "cannot create image from data"))
            }

            return .success(NSImage(cgImage: cgImage, size: NSSize(width: Int(width), height: Int(height))))
            
        default:
            return .failure(Adb.Error.screencap(message: "cannot parse image"))
        }
    }
    
}
