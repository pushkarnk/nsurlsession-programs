import Foundation

public class DataTask: NSObject {
    public var downloading = false
    let baseURL = "https://restcountries.eu/rest/v1/name/"
    public var capital = "unknown"

    public func getCountryData(country: String) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let request = NSURLRequest(URL: NSURL(string: constructURLString(country))!)
        downloading = true
        let task = session.dataTaskWithRequest(request)
        task.resume()
    }
  
    private func constructURLString(country: String) -> String {
        let url = NSMutableString(capacity: 120)
        url.appendString(baseURL)
        url.appendString(country)
        url.appendString("?fullText=true")
        return url as String
    }
}

extension DataTask : NSURLSessionDataDelegate {
    
   public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) { 
       do {
           let json = try NSJSONSerialization.JSONObjectWithData(proposedResponse.data, options: []) 
           capital = json[0]["capital"]!! as! String
       } catch let error as NSError {
           print(error)
       }
       self.downloading = false
   }
}

var d: DataTask
for country in ["India","Japan", "Greece",  "Nepal", "Bangladesh", "Pakistan", "Bhutan", "Afghanistan", "Iceland"] {
    d = DataTask()
    d.getCountryData(country)
    while d.downloading {sleep(1)}
    print ("The capital of \(country) is \(d.capital)")
} 

