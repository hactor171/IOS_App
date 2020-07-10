import Foundation
import UIKit

protocol Downloadable: class {
    func didReceiveData(data: Any)
}


class HttpOperations{
    
    let db = DatabaseHelper()
    
    func get_request(url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
    
        request.timeoutInterval = 5 
        
        return request
    }
    
    func post_request(parameters: [String: Any], url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.timeoutInterval = 5
        
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        return request
    }
    func response(currentId:Int,optype:String, request: URLRequest, completionBlock: @escaping (Data) -> Void) -> Void {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200  else {
                    Alert.displayAlert(message: "Sorry, servers are current unreachable")
                    return
            }
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            completionBlock(data);
            if request.httpMethod == "POST"
            {
                if(optype.elementsEqual("InsTask"))
                {
                    let id:Int = self.db.getLastTaskid()
                    self.db.updateTaskStatus(id: id, status: 1)
                }
                else if(optype.elementsEqual("InsTaskList"))
                {
                    let id:Int = self.db.getLastTaskListid()
                    self.db.updateTaskListStatus(id: id, status: 1)
                }
                else if(optype.elementsEqual("ServerUpdatesList"))
                {
                    let id:Int = self.db.getLastTaskListid()
                    self.db.updateTaskListStatus(id: id, status: 1)
                }
                else if(optype.elementsEqual("ServerUpdatesTask"))
                {
                    let id:Int = self.db.getLastTaskid()
                    self.db.updateTaskStatus(id: id, status: 1)
                }
                else if(optype.elementsEqual("UpdatetTaskcCompletioStatus"))
                {
                    self.db.updateTaskStatus(id: currentId, status: 1)
                }
                else if(optype.elementsEqual("UpdateTaskList"))
                {
                    self.db.updateTaskListStatus(id: currentId, status: 1)
                }
                else if(optype.elementsEqual("DeleteTask"))
                {
                    self.db.droptmpId(id: currentId)
                }
                else if(optype.elementsEqual("DeleteTaskList"))
                {
                    self.db.droptmpId(id: currentId)
                }
            }
        }
        task.resume()
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" 
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


