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
    
    init() {

        _ = APIService.rxFetchAll()
            .subscribe { event in
                switch event {
                case .next(let wineList):
                    self.wineObservable.onNext(wineList)
                    break
                case .completed:
                    break
                case .error:
                    break
                }
            }
        
    }
}
