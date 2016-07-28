import Foundation

public class DataTask: NSObject {
    public var downloading = false
    let baseURL = "https://restcountries.eu/rest/v1/name/"
    public var capital = "unknown"
    var task: URLSessionDataTask! = nil
    var session: URLSession! = nil
    private var country: String

    public init(country: String) {
        self.country = country
    }

    public func getCountryData() {
        let configuration = URLSessionConfiguration.default()
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let request = NSURLRequest(url: URL(string: constructURLString(country: self.country))!)
        task = session.dataTask(with: request)
        task.resume()
        downloading = true
    }
  
    private func constructURLString(country: String) -> String {
        let url = NSMutableString(capacity: 120)
        url.append(baseURL)
        url.append(country)
        url.append("?fullText=true")
        return url.bridge()
    }
}

extension DataTask : URLSessionDataDelegate {
     public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
           let json = try JSONSerialization.jsonObject(with: data, options: [])
           let arr = json as? Array<Any>
           let first = arr![0]
           let result = first as? [String : Any]
           capital = result!["capital"] as! String
        } catch let error as NSError {
           print(error)
        }
        self.downloading = false
    }
}

var d: DataTask
for country in ["India","Japan", "Greece",  "Nepal", "Bangladesh", "Pakistan", "Bhutan", "Afghanistan", "Iceland"] {
    d = DataTask(country: country)
    d.getCountryData()
    while d.downloading {
        print("Waiting") 
        sleep(1)
     }
    print ("The capital of \(country) is \(d.capital)")
} 
