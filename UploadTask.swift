import Foundation

//Simple upload example without a delegate 

public class UploadTask : NSObject {
    public var uploading = false
    let filePath: String
    let fileName: String

    public init( filePath: String) {
        self.filePath = filePath
        let arr = filePath.characters.split("/")
        fileName = String(arr[arr.count-1])
    }
    public func upload() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
         
        let token = "<app token>"
        let authString = "Bearer \(token)"
        
        let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)

        let request = NSMutableURLRequest(URL: NSURL(string: "https://api-content.dropbox.com/1/files_put/auto/\(fileName)")!)
        request.HTTPMethod = "PUT" 
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue(authString, forHTTPHeaderField: "Authorization")

        uploading = true
        let task = session.uploadTaskWithRequest(request, fromData: NSData(contentsOfFile: filePath)!, completionHandler: {
             (_, response, error) in 
                let httpResponse = response as! NSHTTPURLResponse?

                if httpResponse!.statusCode == 200 {
                    print("Upload successful!")
                } else {
                    print(error!.localizedDescription)
                }
 
                self.uploading = false
        })
        task.resume()
    }
}

let e = UploadTask(filePath: "/Users/puskulka/yard/nsurlsession-tests/hello.txt")
e.upload() 
while e.uploading {
    sleep(1)
}



