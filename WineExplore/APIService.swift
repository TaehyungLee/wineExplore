//
//  Logic.swift
//  UTCTime
//
//  Created by Chiwon Song on 2021/05/31.
//

import Foundation
import RxSwift
import FirebaseDatabase
import FirebaseFirestore

class APIService {
    
    static let shared = APIService()
    
    let ref = Database.database().reference()
    
    let LIMIT_CNT = 50
    
    fileprivate var query: Query?
//    private var listener: ListenerRegistration?
    
    fileprivate func baseQuery(_ collectionName:String, limitCnt:Int) -> Query {
        return Firestore.firestore().collection(collectionName).limit(to: limitCnt)
    }
    
    func writeWine(data:WineDataModel) {
        let collection = Firestore.firestore().collection("wines")
        collection.addDocument(data: data.dictionary) { err in
            if let error = err {
                print("err : \(error.localizedDescription)")
            }
        }
    }
    
    func rxReadWine() -> Observable<[WineDataModel]> {
        return Observable.create { emitter in
            let query = self.baseQuery("wines", limitCnt: self.LIMIT_CNT)
            query.getDocuments { snapshot, error in
                if let err = error {
                    emitter.onError(err)
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                let models = snapshot.documents.map { (document) -> WineDataModel in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data() , options: .prettyPrinted)
                        let model = try JSONDecoder().decode(WineDataModel.self, from: data)
                        return model
                    }catch {
                        print("decode fail : \(error.localizedDescription)")
                        return WineDataModel()
                    }
                    
                }
                emitter.onNext(models)
            }
            return Disposables.create()
        }
    }
    
    func rxReadSearchWine(searchStr:String) -> Observable<[WineDataModel]> {
        return Observable.create { emitter in
            let query = self.baseQuery("wines", limitCnt: self.LIMIT_CNT)
            let filterQuery = query.whereField("koreanName", isEqualTo: searchStr)
            filterQuery.getDocuments { snapshot, error in
                if let err = error {
                    emitter.onError(err)
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                print("search List Count : \(snapshot.documents.count)")
                let models = snapshot.documents.map { (document) -> WineDataModel in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data() , options: .prettyPrinted)
                        let model = try JSONDecoder().decode(WineDataModel.self, from: data)
                        return model
                    }catch {
                        print("decode fail : \(error.localizedDescription)")
                        return WineDataModel()
                    }
                    
                }
                emitter.onNext(models)
            }
            return Disposables.create()
        }
    }
    
//    func rxFetchAll() -> Observable<[WineDataModel]> {
//        return Observable.create { emitter in
//            // wine data 요청
//
//            self.fetchNow { result in
//                switch result {
//                case .success(let data):
//                    emitter.onNext(data)
//                    emitter.onCompleted()
//                    break
//                case .failure(let err):
//                    emitter.onError(err)
//                    break
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
    
//    func rxSearchDataFetch(_ searchStr:String) -> Observable<[WineDataModel]> {
//        return Observable.create { emitter in
//            // wine data 요청
//
//            self.fetchNow(searchStr) { result in
//                switch result {
//                case .success(let data):
//                    emitter.onNext(data)
//                    emitter.onCompleted()
//                    break
//                case .failure(let err):
//                    emitter.onError(err)
//                    break
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
//
//    // 검색된 와인만 가져옴
//    func fetchNow(_ searchStr:String, onCompleted: @escaping (Result<[WineDataModel], Error>) -> Void) {
//
//        ref.child("wineList")
//            .observe(.value) { snapshot in
//
//                if let resultValue = snapshot.value as? [[String:Any]] {
//                    // parsing
//                    do {
//                        let data = try JSONSerialization.data(withJSONObject: resultValue , options: .prettyPrinted)
//                        let objList = try JSONDecoder().decode([WineDataModel].self, from: data)
//                        onCompleted(.success(objList))
//
//                    } catch let DecodingError.dataCorrupted(context) {
//                        print(context)
//                        onCompleted(.failure(DecodingError.dataCorrupted(context).self))
//                    } catch let DecodingError.keyNotFound(key, context) {
//                        print("Key '\(key)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                        onCompleted(.failure(DecodingError.keyNotFound(key, context).self))
//                    } catch let DecodingError.valueNotFound(value, context) {
//                        print("Value '\(value)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                        onCompleted(.failure(DecodingError.valueNotFound(value, context).self))
//                    } catch let DecodingError.typeMismatch(type, context)  {
//                        print("Type '\(type)' mismatch:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                        onCompleted(.failure(DecodingError.typeMismatch(type, context).self))
//                    } catch {
//                        print("error: ", error.localizedDescription)
//                    }
//                }else {
//                    onCompleted(.failure(NSError(domain: "no data",
//                                                code: -999,
//                                                userInfo: nil)))
//                }
//
//        }
//
//
//    }
//
//
//    // 전체 리스트 가져옴
//    func fetchNow(onCompleted: @escaping (Result<[WineDataModel], Error>) -> Void) {
//        // wine data 요청
//        ref.child("wineList")
//            .observeSingleEvent(of: .value) { snapshot in
////            .queryOrdered(byChild: "koreanName")
////            .queryStarting(atValue: "16")
////            .observe(.value) { snapshot in
//            if let resultValue = snapshot.value as? [[String:Any]] {
//                // parsing
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: resultValue , options: .prettyPrinted)
//                    let objList = try JSONDecoder().decode([WineDataModel].self, from: data)
//                    onCompleted(.success(objList))
//
//                } catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                    onCompleted(.failure(DecodingError.dataCorrupted(context).self))
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    onCompleted(.failure(DecodingError.keyNotFound(key, context).self))
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    onCompleted(.failure(DecodingError.valueNotFound(value, context).self))
//                } catch let DecodingError.typeMismatch(type, context)  {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    onCompleted(.failure(DecodingError.typeMismatch(type, context).self))
//                } catch {
//                    print("error: ", error.localizedDescription)
//                }
//            }else {
//                onCompleted(.failure(NSError(domain: "no data",
//                                            code: -999,
//                                            userInfo: nil)))
//            }
//        }
//    }
//
//    // 와인 리스트 수신대기
//    func rxObserveWineListAdd() -> Observable<WineDataModel> {
//
//        return Observable.create { emitter in
//
//            let handler = self.ref.observe(.childAdded) { snapshot in
//                guard let value = snapshot.value as? [String:Any] else {
//                    emitter.onError(NSError(domain: "parsing fail", code: -999, userInfo: nil))
//                    return
//                }
//
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: value , options: .prettyPrinted)
//                    let jsonData = try JSONDecoder().decode(WineDataModel.self, from: data)
//                    emitter.onNext(jsonData)
//
//                } catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                    emitter.onError(DecodingError.dataCorrupted(context).self)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    emitter.onError(DecodingError.keyNotFound(key, context).self)
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    emitter.onError(DecodingError.valueNotFound(value, context).self)
//                } catch let DecodingError.typeMismatch(type, context)  {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                    emitter.onError(DecodingError.typeMismatch(type, context).self)
//                } catch {
//                    emitter.onError(error)
//
//                }
//
//            }
//
//            return Disposables.create{
//                self.ref.removeObserver(withHandle: handler)
//            }
//        }
//
//    }
    
}
