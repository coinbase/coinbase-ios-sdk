//
//  RxSpecHelpers.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import RxSwift
import Nimble

func testSubscribe<T>(_ single: Single<T>) {
    _ = single.subscribe()
}
