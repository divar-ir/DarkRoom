//
//  File.swift
//  
//
//  Created by Kiarash Vosough on 7/16/22.
//
//  Copyright (c) 2022 Divar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
