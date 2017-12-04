//
//  RQVersionMana.swift
//  RQVersionMana
//
//  Created by 阮琦 on 2017/12/3.
//  Copyright © 2017年 Q.Roy. All rights reserved.
//

// Copyright (c) 2015 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

private func parseVersion(_ lhs: AppVersion, rhs: AppVersion) -> Zip2Sequence<[Int], [Int]> {
    
    let lhs = lhs.versionString.split(separator: ".").map { (String($0) as NSString).integerValue }
    let rhs = rhs.versionString.split(separator: ".").map { (String($0) as NSString).integerValue }
    let count = max(lhs.count, rhs.count)
    return zip(
        lhs + Array(repeating: 0, count: count - lhs.count),
        rhs + Array(repeating: 0, count: count - rhs.count))
}

public func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
    
    var result: Bool = true
    for (l, r) in parseVersion(lhs, rhs: rhs) {
        
        if l != r {
            result = false
        }
    }
    return result
}

public func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
    
    for (l, r) in parseVersion(lhs, rhs: rhs) {
        if l < r {
            return true
        } else if l > r {
            return false
        }
    }
    return false
}

public func > (lhs: AppVersion, rhs: AppVersion) -> Bool {
    
    for (l, r) in parseVersion(lhs, rhs: rhs) {
        if l > r {
            return true
        } else if l < r {
            return false
        }
    }
    return false
}

public struct AppVersion: ExpressibleByStringLiteral, Comparable {
    
    public static var marketingVersion: AppVersion {
        
        if let dic = Bundle.main.infoDictionary {
            return AppVersion(dic["CFBundleShortVersionString"] as! String)
        } else {
            fatalError()
        }
    }
    
    public static var version: AppVersion {
        
        if let dic = Bundle.main.infoDictionary {
            return AppVersion(dic[kCFBundleVersionKey as String] as! String)
        } else {
            fatalError()
        }
    }
    
    fileprivate(set) public var versionString: String
    
    public init(_ versionString: String) {
        
        self.versionString = versionString
    }
    
    // MARK: StringLiteralConvertible
    
    public init(stringLiteral value: String) {
        
        self.versionString = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        
        self.versionString = value
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        
        self.versionString = value
    }
}

extension AppVersion: CustomStringConvertible {
    public var description: String {
        return self.versionString
    }
}


open class RQVersionMana {
    
    public enum State: Equatable {
        public static func ==(lhs: RQVersionMana.State, rhs: RQVersionMana.State) -> Bool {
            return lhs == rhs
        }
        
        case notChanged
        case installed
        case upgraded(previousVersion: AppVersion)
        case downgraded(previousVersion: AppVersion)
    }
    
    open static let shared = RQVersionMana()
    
    open let state: State
    open let installedVersions: [AppVersion]
    
    open func startup() {
        
    }
    
    init() {
        
        let userDefaults = UserDefaults(suiteName: RQVersionMana.userDefaultsSuitename)
        defer {
            userDefaults?.synchronize()
        }
        
        var installedVersions = (userDefaults?.object(forKey: RQVersionMana.installedVersionsKey) as? [String])?.map { AppVersion($0) } ?? []
        
        let _latestVersionString = userDefaults?.string(forKey: RQVersionMana.latestVersionKey)
        userDefaults?.set(AppVersion.marketingVersion.versionString, forKey: RQVersionMana.latestVersionKey)
        
        if installedVersions.contains(AppVersion.marketingVersion) == false {
            
            installedVersions.append(AppVersion.marketingVersion)
            userDefaults?.set(installedVersions.map { $0.versionString }, forKey: RQVersionMana.installedVersionsKey)
        }
        
        self.installedVersions = installedVersions
        
        guard let latestVersionString = _latestVersionString else {
            
            self.state = .installed
            return
            
        }
        
        let latestVersion = AppVersion(latestVersionString)
        
        if latestVersion < AppVersion.marketingVersion {
            
            self.state = .upgraded(previousVersion: latestVersion)
            
        } else if latestVersion > AppVersion.marketingVersion {
            
            self.state = .downgraded(previousVersion: latestVersion)
            
        } else {
            
            self.state = .notChanged
        }
    }
    
    fileprivate static let latestVersionKey = "Q.Roy.VersionMana.latestVersion"
    fileprivate static let installedVersionsKey = "Q.Roy.VersionMana.installedVersionsKey"
    fileprivate static let userDefaultsSuitename = "Q.Roy.VersionMana.AppVersionMonitor"
}
