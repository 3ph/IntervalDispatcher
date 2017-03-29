//
//  IntervalDispatcher.swift
//  GenieApp
//
//  Created by Tomas Friml on 29/03/17.
//


/// Simple dispatcher which will execute (newest) task only
/// once per specified interval. Tasks can be added any time
/// only the newest gets executed
/// NOTE: Uses main queue so the timing is not perfect
class IntervalDispatcher {
    
    
    /// Adds (replaces) the current waiting task and schedule
    /// it's execution
    ///
    /// - Parameter task: New task
    open func append(task: @escaping () -> Void) {
        if let task = _task {
            task.cancel()
        }
        
        _task = DispatchWorkItem(block: task)
        
        let intervalSinceLastExecution = NSDate().timeIntervalSince1970 - _lastExecutionEpoch
        // figure out the difference and either execute now or wait for next interval
        let difference = max(0, _interval - intervalSinceLastExecution)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + difference, execute: {
            self.executeTask()
        })
    }

    
    // MARK: - Private
    fileprivate let _interval : TimeInterval
    fileprivate var _lastExecutionEpoch : TimeInterval = 0
    fileprivate var _task : DispatchWorkItem?
    
    required init(interval: TimeInterval) {
        _interval = interval
    }
    
    fileprivate func executeTask() {
        _task?.perform()
        _task = nil
        _lastExecutionEpoch = NSDate().timeIntervalSince1970
    }
    
}
