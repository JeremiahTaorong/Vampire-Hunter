import Foundation
import ImageIO

let folder = URL(fileURLWithPath: CommandLine.arguments[1])
let output = URL(fileURLWithPath: CommandLine.arguments[2])
let files = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil).filter { $0.pathExtension == "png" }.sorted { $0.lastPathComponent < $1.lastPathComponent }
guard let destination = CGImageDestinationCreateWithURL(output as CFURL, "com.compuserve.gif" as CFString, files.count, nil) else { fatalError("Cannot create GIF") }
CGImageDestinationSetProperties(destination, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary)
for (index, file) in files.enumerated() {
    guard let source = CGImageSourceCreateWithURL(file as CFURL, nil),
          let frame = CGImageSourceCreateThumbnailAtIndex(source, 0, [kCGImageSourceCreateThumbnailFromImageAlways: true, kCGImageSourceThumbnailMaxPixelSize: 960] as CFDictionary) else { fatalError("Cannot read frame") }
    let duration = index == 0 ? 0.18 : (index == files.count - 1 ? 0.25 : 1.0 / 30.0)
    CGImageDestinationAddImage(destination, frame, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: duration, kCGImagePropertyGIFUnclampedDelayTime: duration]] as CFDictionary)
}
guard CGImageDestinationFinalize(destination) else { fatalError("Cannot finish GIF") }
print("Saved \(files.count) frames to \(output.path)")
