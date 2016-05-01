import Foundation

public class Espresso : NSObject {

    public var running: Bool = false

    public func download() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = "<username>:<password>"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions([])
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)

        self.running = false
        let url = NSURL(string: "<complete url>")
        let task = session.downloadTaskWithURL(url!)
        self.running = true
        task.resume()
    }
}


extension Espresso : NSURLSessionDownloadDelegate {

    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, 
                              totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = Int(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) * 100)
        let something = "|\(Util.stars(percentage))[\(percentage)%]\r"
        print(something, terminator: "")
        fflush(__stdoutp)  
    }

    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("\nFinished download!")
        self.running = false
    }
}

class Util {
 internal class func stars(n: Int) -> String {
        let st = NSMutableString(capacity: 100)
        guard n > 0 else {
            return st as String
        }
        for _ in 1...n {
            st.appendString("*")
        }
        return st as String
    }
}

//main
let e = Espresso()
e.download()
while e.running {
    sleep(1)
}
