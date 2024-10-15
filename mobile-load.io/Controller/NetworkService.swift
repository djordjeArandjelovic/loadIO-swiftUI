//
//  NetworkService.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 26.6.24..
//

import Foundation
import Combine
import UIKit

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private var cancellables = Set<AnyCancellable>()
    private var token: String?
    private var driverID: Int?
    
    func setToken(_ token: String) {
        self.token = token
    }
    
    var hasToken: Bool {
        return token != nil
    }
    
    func createRequest(withUrl: URL, httpMethod: String = "GET") -> URLRequest? {
        guard let token = token else { return nil }
        var request = URLRequest(url: withUrl)
        request.httpMethod = httpMethod
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Token added to request: \(token)")
        return request
    }
    
    func loginWithUsernameAndPassword(email: String, username: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        guard let url = URL(string: "https://dev.az.loadio.app/admin/api/Accounts/Login") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "username": username,
            "password": password,
            "clientURI": "https://dev.loadio.app/"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] response in
                if response.isAuthSuccessful {
                    guard let token = response.token else { return }
                    self?.setToken(token)
                    if let employee = response.employee {
                        self?.driverID = employee.employeeIdForeign
                        print("Login successful! Driver ID (employeeIdForeign): \(employee.employeeIdForeign)")
                    } else {
                        print("Employee information is missing.")
                    }
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func fetchLoadsByDriver() -> AnyPublisher<[SingleLoad], Error> {
        guard let driverID = driverID,
              let url = URL(string: "https://dev.loadio.app/loads/GetLoadsByDriver?driverID=\(driverID)"),
              let request = createRequest(withUrl: url) else {
            print("Failed to create a request or driverID is nil.")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [SingleLoad].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchAllLoads() -> AnyPublisher<[SingleLoad], Error> {
        print("Attempting to fetch data...")
        
        guard let url = URL(string: APIEndpoints.getAllLoadsEndpoint),
              let request = createRequest(withUrl: url) else {
            print("Failed to create request...")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        print("Success!")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [SingleLoad].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchLoadDetail(loadID: Int) -> AnyPublisher<SingleLoad, Error> {
        guard let url = URL(string: "\(APIEndpoints.getLoadDetailedEndpoint)\(loadID)"),
              let request = createRequest(withUrl: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SingleLoad.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func uploadImages(url: URL, images: [UIImage], fileName: String) -> AnyPublisher<Void, Error> {
        print("Attempting to upload images to URL: \(url)")
        
        var imageDatas: [(Data, String)] = []
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let filename = "upload\(index)-\(fileName).jpg"
                imageDatas.append((imageData, filename))
            }
        }
        
        guard !imageDatas.isEmpty,
              var request = createRequest(withUrl: url, httpMethod: "POST") else {
            print("Failed to create request or convert images to data.")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createBody(boundary: boundary, imageDatas: imageDatas)
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Received HTTP response: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func sendCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "httpss://www.postCoordinates.com"), // MARK: replace with actual url
              var request = createRequest(withUrl: url, httpMethod: "POST") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let body: [String: Any] = ["latitude": latitude, "longitude": longitude]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serilizing JSON: \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
}

private extension NetworkService {
    func createBody(boundary: String, imageDatas: [(Data, String)]) -> Data {
        var body = Data()
        
        for (data, filename) in imageDatas {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        body.append("--\(boundary)--\r\n")
        
        return body
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
