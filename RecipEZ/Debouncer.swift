//
//  Debouncer.swift
//  RecipEZ
//
//  Created by Ethan Yu on 6/14/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import Foundation

class Debouncer {
    
    typealias Handler = () -> Void
    var handler: Handler?
    
    let timeInterval: TimeInterval
    var timer: Timer?
    
    init (timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func renew() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: {[weak self] timer in self?.handleTimer(timer)})
    }
    
    private func handleTimer(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
        handler = nil
    }
    
}
