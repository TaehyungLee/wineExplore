//
//  Logic.swift
//  UTCTime
//
//  Created by Chiwon Song on 2021/05/31.
//

import Foundation
import RxSwift
import FirebaseDatabase

class APIService {
    static let ref = Database.database().reference()
    
    static func rxFetchAll() -> Observable<[WineDataModel]> {
        return Observable.create { emitter in
            // wine data 요청
            
            fetchNow { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                    break
                case .failure(let err):
                    emitter.onError(err)
                    break
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func rxSearchDataFetch(_ searchStr:String) -> Observable<[WineDataModel]> {
        return Observable.create { emitter in
            // wine data 요청
            
            fetchNow(searchStr) { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                    break
                case .failure(let err):
                    emitter.onError(err)
                    break
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 검색된 와인만 가져옴
    static func fetchNow(_ searchStr:String, onCompleted: @escaping (Result<[WineDataModel], Error>) -> Void) {
        
        ref.child("wineList")
            .queryOrdered(byChild: "koreanName")
            .queryStarting(atValue: searchStr)
            .queryEnding(atValue: searchStr + "uf8ff")
            .observe(.value) { snapshot in
            
                if let resultValue = snapshot.value as? [[String:Any]] {
                    // parsing
                    do {
                        let data = try JSONSerialization.data(withJSONObject: resultValue , options: .prettyPrinted)
                        let objList = try JSONDecoder().decode([WineDataModel].self, from: data)
                        onCompleted(.success(objList))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        onCompleted(.failure(DecodingError.dataCorrupted(context).self))
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        onCompleted(.failure(DecodingError.keyNotFound(key, context).self))
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        onCompleted(.failure(DecodingError.valueNotFound(value, context).self))
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        onCompleted(.failure(DecodingError.typeMismatch(type, context).self))
                    } catch {
                        print("error: ", error.localizedDescription)
                    }
                }else {
                    onCompleted(.failure(NSError(domain: "no data",
                                                code: -999,
                                                userInfo: nil)))
                }
                
        }
        
        
    }
    
    
    // 전체 리스트 가져옴
    static func fetchNow(onCompleted: @escaping (Result<[WineDataModel], Error>) -> Void) {
        // wine data 요청
        ref.child("wineList")
            .queryOrdered(byChild: "koreanName")
            .observeSingleEvent(of: .value) {snapshot in
//        db.child("wineList").queryOrdered(byChild: "koreanName").queryStarting(atValue: "16").observe(.value) { snapshot in
            if let resultValue = snapshot.value as? [[String:Any]] {
                // parsing
                do {
                    let data = try JSONSerialization.data(withJSONObject: resultValue , options: .prettyPrinted)
                    let objList = try JSONDecoder().decode([WineDataModel].self, from: data)
                    onCompleted(.success(objList))
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    onCompleted(.failure(DecodingError.dataCorrupted(context).self))
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    onCompleted(.failure(DecodingError.keyNotFound(key, context).self))
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    onCompleted(.failure(DecodingError.valueNotFound(value, context).self))
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    onCompleted(.failure(DecodingError.typeMismatch(type, context).self))
                } catch {
                    print("error: ", error.localizedDescription)
                }
            }else {
                onCompleted(.failure(NSError(domain: "no data",
                                            code: -999,
                                            userInfo: nil)))
            }
        }
    }

    // 와인 리스트 수신대기
    static func rxObserveWineListAdd() -> Observable<WineDataModel> {
        
        return Observable.create { emitter in
            
            let handler = ref.observe(.childAdded) { snapshot in
                guard let value = snapshot.value as? [String:Any] else {
                    emitter.onError(NSError(domain: "parsing fail", code: -999, userInfo: nil))
                    return
                }
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: value , options: .prettyPrinted)
                    let jsonData = try JSONDecoder().decode(WineDataModel.self, from: data)
                    emitter.onNext(jsonData)
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    emitter.onError(DecodingError.dataCorrupted(context).self)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    emitter.onError(DecodingError.keyNotFound(key, context).self)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    emitter.onError(DecodingError.valueNotFound(value, context).self)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    emitter.onError(DecodingError.typeMismatch(type, context).self)
                } catch {
                    emitter.onError(error)
                    
                }
                
            }
            
            return Disposables.create{
                ref.removeObserver(withHandle: handler)
            }
        }
        
    }
    
}
