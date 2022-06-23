//
//  ViewModel.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/16.
//

import Foundation
import RxSwift

class ViewModel {
    
    // 초기값을 가지는 subject
    var wineObservable = BehaviorSubject<[WineDataModel]>(value: [])
    var disposeBag = DisposeBag()
    
    init() {
        
        APIService.shared.rxReadWine()
            .subscribe(onNext: { wines in
                self.wineObservable.onNext(wines)
            }, onError: { err in
                print("read wine error : \(err.localizedDescription)")
            }).disposed(by: disposeBag)
        
    }
    
    func searchWine(searchStr:String) {
        APIService.shared.rxReadSearchWine(searchStr: searchStr)
            .subscribe(onNext:{ wines in
                self.wineObservable.onNext(wines)
            }, onError: { err in
                print("read wine error : \(err.localizedDescription)")
            }).disposed(by: disposeBag)
    }
}
