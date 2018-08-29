//
//  IndexedDataSource.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class IndexedDataSource<T>: NSObject, UITableViewDataSource {
    
    var items: [T] = [] {
        didSet {
            itemSections = Dictionary(grouping: items, by: groupingKeyForItem)
        }
    }
    
    init(cellIdentifier: String,
         groupingBy: @escaping (T) -> String,
         configuration: @escaping (UITableViewCell, T) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.configurationClosure = configuration
        self.groupingKeyForItem = groupingBy
    }
    
    // MARK: - Private properies
    
    private let cellIdentifier: String
    private let configurationClosure: (UITableViewCell, T) -> Void
    private let groupingKeyForItem: (T) -> String
    
    private var itemSections: [String: [T]] = [:] {
        didSet {
            sectionTitles = itemSections.keys.sorted()
        }
    }
    private var sectionTitles: [String] = []
    
    // MARK: - UITableViewDataSource
    
    func item(at indexPath: IndexPath) -> T? {
        let titleIndex = sectionTitles[indexPath.section]
        return itemSections[titleIndex]?[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let titleIndex = sectionTitles[section]
        return itemSections[titleIndex]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let item = item(at: indexPath) else { return UITableViewCell() }
        configurationClosure(cell, item)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
}
