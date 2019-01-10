//
//  Promise.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents a functional abstraction around a failable asynchronous operation that can be chained.
///
/// Once a promise is `fulfilled` or `rejected`, it's state is immutable.
///
public final class Promise<Value> {
    
    /// Current state of the promise.
    private var state: State<Value> = .pending
    /// An array of callbacks to call when promise is resolved.
    private var callbacks: [Callback<Value>] = []
    /// Queue used to synchronize access.
    private let lockQueue = DispatchQueue(label: "coinbase_promise_lock_queue", qos: .userInitiated)
    
    /// Initialize a new promise with default `pending` state.
    public init() {
        state = .pending
    }
    
    /// Initialize a new fulfilled promise with provided value.
    ///
    /// - Parameter value: Provided value.
    ///
    public init(value: Value) {
        state = .fulfilled(value)
    }
    
    /// Initialize a new rejected promise with provided error.
    ///
    /// - Parameter error: Provided value.
    ///
    public init(error: Error) {
        state = .rejected(error)
    }
    
    /// Initialize a new promise with closure to perform.
    ///
    /// - Parameters:
    ///   - queue: Queue to dispatch provided work on.
    ///   - work: Closure to perform.
    ///    - fulfill: Closure to call to fulfill current promise.
    ///     - value: Associated value.
    ///    - reject: Closure to call to reject current promise.
    ///     - error: Associated error.
    ///
    public convenience init(queue: DispatchQueue = .global(qos: .userInitiated),
                            work: @escaping (_ fulfill: @escaping (_ value: Value) -> Void, _ reject: @escaping (_ error: Error) -> Void ) -> Void) {
        self.init()
        queue.async {
            work(self.fulfill, self.reject)
        }
    }
    
}

// MARK: - Resolving promise Methods

internal extension Promise {
    
    /// Resolves promise either with `fulfilled` or `rejected` state and fires all callbacks.
    ///
    /// - Note:
    ///     Once a promise is resolved, it's state is immutable.
    ///
    /// - Parameter state: Resolution state.
    ///
    ///     Can be either with `fulfilled` or `rejected`.
    ///
    private func resolve(with state: State<Value>) {
        guard self.isPending else {
            return
        }
        lockQueue.sync {
            self.state = state
        }
        fireCallbacksIfResolved()
    }
    
    /// Fulfills the promise with the provided value.
    ///
    /// - Parameter value: Provided value.
    ///
    private func fulfill(_ value: Value) {
        resolve(with: .fulfilled(value))
    }
    
    /// Rejects the promise with the underlying error.
    ///
    /// - Parameter error: Error representing reason for rejection.
    ///
    private func reject(_ error: Error) {
        resolve(with: .rejected(error))
    }
    
}

// MARK: - Convenience Methods

public extension Promise {
    
    /// `true` if promise is neither fulfilled nor rejected; otherwise, `false`.
    public var isPending: Bool {
        return !isFulfilled && !isRejected
    }
    
    /// `true` if promise completed successfully; otherwise, `false`.
    public var isFulfilled: Bool {
        return value != nil
    }
    
    /// `true` if promise failed; otherwise, `false`.
    public var isRejected: Bool {
        return error != nil
    }
    
    /// Returns associated value if promise completed successfully; otherwise, returns `nil`.
    public var value: Value? {
        return lockQueue.sync(execute: {
            return self.state.value
        })
    }
    
    /// Returns associated error if promise failed; otherwise, returns `nil`.
    public var error: Error? {
        return lockQueue.sync(execute: {
            return self.state.error
        })
    }
    
}

// MARK: - Callbacks

private extension Promise {
    
    /// Creates callback from given parameters and tries to fire all callbacks if promise is resolved.
    ///
    /// - Parameters:
    ///   - queue: Queue to dispatch provided closures on.
    ///   - onFulfill: Closure to call in case promise is resolved with `fulfilled` state.
    ///    - value: Associated value.
    ///   - onReject: Closure to call in case promise is resolved with `rejected` state.
    ///    - error: Associated error.
    ///
    private func addCallbacks(on queue: DispatchQueue = .main,
                              onFulfill: @escaping (_ value: Value) -> Void,
                              onReject: @escaping (_ error: Error) -> Void) {
        let callback = Callback(onFulfill: onFulfill, onReject: onReject, queue: queue)
        lockQueue.async {
            self.callbacks.append(callback)
        }
        fireCallbacksIfResolved()
    }
    
    /// Fires and removes all callbacks in case promise is resolved.
    private func fireCallbacksIfResolved() {
        lockQueue.async {
            guard !self.state.isPending else { return }
            self.callbacks.forEach { callback in
                switch self.state {
                case let .fulfilled(value):
                    callback.callFulfill(value)
                case let .rejected(error):
                    callback.callReject(error)
                default:
                    break
                }
            }
            self.callbacks.removeAll()
        }
    }
    
}

// MARK: - Chaining Methods

public extension Promise {
    
    /// Adds callback to be executed when the promise is resolved.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke closures closure on.
    ///   - onFulfill: Closure to call in case promise is resolved with `fulfilled` state.
    ///    - value: Associated value.
    ///   - onReject: Closure to call in case promise is resolved with `rejected` state.
    ///    - error: Associated error.
    ///
    /// - Returns:
    ///     The same `Promise` instance.
    ///
    @discardableResult
    public func then(on queue: DispatchQueue = .main,
                     _ onFulfill: @escaping (_ value: Value) -> Void,
                     _ onReject: @escaping (_ error: Error) -> Void = { _ in }) -> Promise<Value> {
        addCallbacks(on: queue, onFulfill: onFulfill, onReject: onReject)
        return self
    }
    
    /// Creates a new `Promise` instance that maps current promise value and adds callback
    /// to be executed when the promise is resolved.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke the `onComplete` closure on.
    ///   - onFulfill: Closure to map promise value in case promise is resolved with `fulfilled` state.
    ///    - value: Associated value to map.
    ///
    /// - Returns:
    ///     A new `Promise` instance.
    ///
    @discardableResult
    public func then<NewValue>(on queue: DispatchQueue = .main,
                               _ onFulfill: @escaping (_ value: Value) throws -> NewValue) -> Promise<NewValue> {
        return Promise<NewValue>(queue: queue) { fulfill, reject in
            self.then(on: queue, { value in
                do {
                    fulfill(try onFulfill(value))
                } catch {
                    reject(error)
                }
            }, reject)
        }
    }
    
    /// Creates a new `Promise` instance that flatmaps current promise value and adds callback
    /// to be executed when the promise is resolved.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke the `onComplete` closure on.
    ///   - onFulfill: Closure to map promise value to new promise in case current promise is resolved with `fulfilled` state.
    ///    - value: Associated value to map.
    ///
    /// - Returns:
    ///     A new `Promise` instance.
    ///
    @discardableResult
    public func then<NewValue>(on queue: DispatchQueue = .main,
                               _ onFulfill: @escaping (_ value: Value) throws -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue>(queue: queue) { fulfill, reject in
            self.then(on: queue, { value in
                do {
                    try onFulfill(value).then(on: queue, fulfill, reject)
                } catch {
                    reject(error)
                }
            }, reject)
        }
    }
    
    /// Provides a new promise to recover in case current promise gets rejected.
    ///
    /// Rejecting a promise cascades: rejecting all subsequent promises. Thus it is recommended to
    /// place `recover` at the end of a chain.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke the `onReject` closure on.
    ///   - onReject: The closure to execute if current promise promise is rejected.
    ///    - error: The error that promise was rejected with.
    ///
    /// - Returns:
    ///     A new `Promise` instance.
    ///
    @discardableResult
    public func recover(on queue: DispatchQueue = .main,
                        _ onReject: @escaping (_ error: Error) throws -> Promise<Value>) -> Promise<Value> {
        return Promise(queue: queue) { fulfill, reject in
            self.then(on: queue, fulfill, { error in
                do {
                    try onReject(error).then(on: queue, fulfill, reject)
                } catch {
                    reject(error)
                }
            })
        }
    }
    
    /// Provides a new promise to catch error in case current promise chain gets rejected.
    ///
    /// Rejecting a promise cascades: rejecting all subsequent promises. Thus it is recommended to
    /// place `catch` at the end of a chain.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke the `onReject` closure on.
    ///   - onReject: The closure to execute if current promise chain is rejected.
    ///    - error: The error that promise was rejected with.
    ///
    /// - Returns:
    ///     The same `Promise` instance.
    ///
    @discardableResult
    public func `catch`(on queue: DispatchQueue = .main,
                        _ onReject: @escaping (_ error: Error) -> Void) -> Promise<Value> {
        return then(on: queue, { _ in }, onReject)
    }
    
    /// Adds callback to be executed when the promise is either fulfilled or rejected.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke the `onComplete` closure on.
    ///   - onComplete: The closure to execute when the promise is either fulfilled or rejected.
    ///
    /// - Returns:
    ///     The same `Promise` instance.
    ///
    @discardableResult
    public func finally(on queue: DispatchQueue = .main,
                        _ onComplete: @escaping () -> Void) -> Promise<Value> {
        return then(on: queue, { _ in onComplete() }, { _ in onComplete() })
    }
    
}
