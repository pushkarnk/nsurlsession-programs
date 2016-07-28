import Foundation

public class Espresso : NSObject {
    
    internal var running: Bool = false
    var currDownload: Int64 = -1 
    
    internal func download(urlString: String) {
        let config = URLSessionConfiguration.default()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        self.running = false
        let url = URL(string: urlString)
        let task = session.downloadTask(with: url!)
        task.resume()
        self.running = true
        while self.running {
            print("Waiting ...")
            sleep(1)
        }
    }
}


extension Espresso : URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void {
        print(totalBytesWritten)
        let percentage = (Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)) * 100
        if Int64(percentage) != currDownload  {
            print("\(Int(percentage))%")
            currDownload = Int64(percentage)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\nFinished download at \(location.absoluteString)!")
        do {
            let attr = try FileManager.default().attributesOfItem(atPath: location.path!)
            print((attr[NSFileSize]! as? NSNumber)!.intValue)
        } catch {
           print("Error: \(error)")
        }
        self.running = false
    }

}


let e = Espresso()
e.download(urlString: "https://swift.org/LICENSE.txt")
