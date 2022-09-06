//
//  File.swift
//  
//
//  Created by Kiarash Vosough on 7/16/22.
//

import Foundation
import Combine

extension Publisher {
    
    internal func publish<S>(on subject: S) -> AnyCancellable where S: Subject, S.Output == Self.Output, S.Failure == Self.Failure {
        return self.sink { [weak subject] completion in
            guard let subject = subject else { return }
            subject.send(completion: completion)
        } receiveValue: { [weak subject] output in
            guard let subject = subject else { return }
            subject.send(output)
        }
    }

    internal func filter<S>(or publishSubject: S, _ isIncluded: @escaping () -> Bool) -> Publishers.Filter<Self> where S: Subject, S.Failure == Never, S.Output == Void {
        return self.filter { [weak publishSubject] output in
            guard let publishSubject = publishSubject else { return false }
            if isIncluded() {
                return true
            } else {
                publishSubject.send()
                return false
            }
        }
    }
    
    internal func receiveOnMainQueue() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        self.receive(on: DispatchQueue.main)
    }
}
