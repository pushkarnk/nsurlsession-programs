import Foundation

//Simple upload example without a delegate 

public class UploadTask : NSObject {
    public var uploading = false
    let filePath: String
    let fileName: String
    var task: URLSessionDataTask! = nil
    var session: URLSession! = nil
    var request: NSMutableURLRequest! = nil


    public init( filePath: String) {
        self.filePath = filePath
        let arr = filePath.components(separatedBy: "/") //.characters.split("/")
        fileName = String(arr[arr.count-1])
    }
    public func upload() {
        let config = URLSessionConfiguration.default()
         
        let token = "DNgx_edczdsAAAAAAAAES41AWvsFJ25lO2YmxNYQS0UK3TSPCEXqZM6Efa-m4gX4"
        let authString = "Bearer \(token)"
        
        session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)

        request = NSMutableURLRequest(url: URL(string: "https://api-content.dropbox.com/1/files_put/auto/\(fileName)")!)
        request.httpMethod = "PUT" 
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        var fileData: Data! = nil
        do {
            fileData =  try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch {print("Oh")}

        print(fileData)
        task = session.uploadTask(with: request, fromData: fileData, completionHandler: {
             (_, response, error) in 
                let httpResponse = response as! NSHTTPURLResponse?

                if httpResponse!.statusCode == 200 {
                    print("Upload successful!")
                } else {
                    print("Error")
                }
 
                self.uploading = false
        })
        task.resume()
        uploading = true
    }
}

let e = UploadTask(filePath: "/root/pushkar/nsurlsession/tests/prepare.sh")
e.upload() 
while e.uploading {
    sleep(1)
}
