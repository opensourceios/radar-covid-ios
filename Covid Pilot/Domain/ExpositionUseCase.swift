//
//  ExpositionUseCase.swift
//  Covid Pilot
//
//  Created by alopezh on 09/06/2020.
//  Copyright © 2020 Indra. All rights reserved.
//

import DP3TSDK
import Foundation
import RxSwift

class ExpositionUseCase: DP3TTracingDelegate {
    
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    private let subject = BehaviorSubject<ExpositionInfo>(value: ExpositionInfo(level: .Healthy))
    
    private let expositionInfoRepository: ExpositionInfoRepository
    private let notificationHandler: NotificationHandler
    private let kpiControllerApi: KpiControllerAPI
    
    init(notificationHandler: NotificationHandler,
         expositionInfoRepository: ExpositionInfoRepository,
         kpiControllerApi: KpiControllerAPI) {
        self.notificationHandler = notificationHandler
        self.expositionInfoRepository = expositionInfoRepository
        self.kpiControllerApi = kpiControllerApi
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss.SSS z"
        DP3TTracing.delegate = self
    }
    
    func DP3TTracingStateChanged(_ state: TracingState) {
        let expositionInfo = tracingStatusToExpositionInfo(tStatus: state)
        subject.onNext(expositionInfo)
        if (showNotification(expositionInfo)) {
            notificationHandler.scheduleNotification(expositionInfo: expositionInfo)
            kpiControllerApi.saveKpi(body: [KpiDto(
                kpi: .matchConfirmed,
                timestamp: dateFormatter.string(from: Date()),
                value: 1)]).subscribe (
                onError: { error in
                        debugPrint("Erorr sending MatchConfirmed KPI \(error)")
                }, onCompleted:{
                    debugPrint("MatchConfirmed KPI sent")
                }).disposed(by: disposeBag)
        }
        expositionInfoRepository.save(expositionInfo: expositionInfo)
    }
    
    
    func getExpositionInfo() -> Observable<ExpositionInfo> {
        subject.asObservable()
    }
    
    func getExpositionInfoFromRepository() -> ExpositionInfo! {
        return expositionInfoRepository.getExpositionInfo() ?? ExpositionInfo(level: .Healthy)
    }
    
    func updateExpositionInfo() {
        
        DP3TTracing.status { result in
            switch result {
            case let .success(state):
                subject.onNext(tracingStatusToExpositionInfo(tStatus: state))
            case .failure:
                subject.onError("Error retrieving exposition status")
            }
        }

    }
    
    // Metodo para mapear un TracingState a un ExpositionInfo
    private func tracingStatusToExpositionInfo(tStatus: TracingState) -> ExpositionInfo {
        switch tStatus.infectionStatus {
        case .healthy:
            var info = ExpositionInfo(level: ExpositionInfo.Level.Healthy)
            info.lastCheck = tStatus.lastSync
            return info
        case .infected:
            return ExpositionInfo(level: ExpositionInfo.Level.Infected)
        case .exposed(days: let days):
            var info = ExpositionInfo(level: ExpositionInfo.Level.Exposed)
            info.since = days.first?.exposedDate
            info.lastCheck = tStatus.lastSync
            return info
        }
    }
    
    private func showNotification(_ expositionInfo: ExpositionInfo) -> Bool {
        if let localEI = expositionInfoRepository.getExpositionInfo() {
            return !equals(localEI, expositionInfo) && expositionInfo.level == .Exposed
        }
        return false
    }

    private func equals(_ ei1: ExpositionInfo, _ ei2: ExpositionInfo) -> Bool {
        ei1.level == ei2.level && ei1.since == ei2.since
    }

    
}
