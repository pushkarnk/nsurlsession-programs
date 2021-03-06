import Foundation

//DownloadTask
public class DownloadTask : NSObject {

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
            sleep(1)
        }
    }
}


extension DownloadTask : URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void {
        let percentage = (Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)) * 100
        if Int64(percentage) != currDownload  {
            print("\(Int(percentage))%")
            currDownload = Int64(percentage)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\nFinished download at \(location.absoluteString)!")
        self.running = false
    }

}

let e = DownloadTask()
e.download(urlString: "https://swift.org/LICENSE.txt")
