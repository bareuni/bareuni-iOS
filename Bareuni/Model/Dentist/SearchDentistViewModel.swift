//
//  SearchDentistViewModel.swift
//  Bareuni
//
//  Created by 황인성 on 2023/09/05.
//

import Foundation
import Combine
import Moya

class SearchDentistViewModel: ObservableObject {
    @Published var isSuccess = false
    @Published var searchDentists = [SearchDentist]()
    private let provider = MoyaProvider<DentistAPI>()
    @Published var keyword = ""
    //            didSet {
    //                fetchSearchDentists()
    //            }
    //        }
    
    init() {
        fetchSearchDentists()
    }
    
    //    func fetchSearchDentists() {
    //        provider.request(.getSearchDentist(keyword: keyword)) { result in
    //            switch result {
    //            case let .success(response):
    //                do {
    //                    let searchDentistResponse = try response.map(SearchDentistResponse.self)
    //                    self.searchDentists = searchDentistResponse.result
    //                } catch {
    //                    print("Error parsing response: \(error)")
    //                }
    //
    //            case let .failure(error):
    //                print("Network request failed: \(error)")
    //            }
    //        }
    //    }
    func fetchSearchDentists() {
        provider.request(.getSearchDentist(keyword: keyword)) { result in
            switch result {
            case let .success(response):
                do {
                    // Convert response data to a string for debugging
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response Data:\n\(responseString)")
                    } else {
                        print("Response Data is not a valid UTF-8 string.")
                    }
                    
                    let searchDentistResponse = try response.map(SearchDentistResponse.self)
                    self.searchDentists = searchDentistResponse.result
                    self.isSuccess = true
                } catch {
                    print("Error parsing response: \(error)")
                    self.isSuccess = false
                }
                
            case let .failure(error):
                print("Network request failed: \(error)")
            }
        }
    }
    
}
