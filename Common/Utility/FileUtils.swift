//
//  FileUtils.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/2/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import Foundation

public class FileUtils {
    
    /// 延迟属性，用到时再初始化
    public static let fileManager = NSFileManager.defaultManager()
    
    /// 获取根目录
    public static var homeDirectory: String {
        return NSHomeDirectory()
    }
    
    /// temp目录，提供一个即时创建临时文件的地方。
    public static var temporaryDirectory: String {
        return NSTemporaryDirectory()
    }
    
    /// 获取Documents文件夹目录
    /// 苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下
    /// iTunes备份和恢复的时候会包括此目录
    public static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    public static var documentDirectoryURL: NSURL {
        return fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    
    /// 获取Library/Caches目录，存放缓存文件
    /// iTunes不会备份此目录
    /// 此目录下文件不会在应用退出删除
    public static var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
    }
    
    public static var cachesDirectoryURL: NSURL {
        return fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
    }
    
    /// Library目录，存储程序的默认设置或其它状态信息；
    public static var libraryDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    }
    
    public static var libraryDirectoryURL: NSURL {
        return fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)[0]
    }
    
    /**
     判断在指定的路径是否存在文件或者目录。
     
     - parameter path: 指定路径
     
     - returns: Bool 值标示文件或目录是否存在；true存在，false不存在。
     */
    public class func fileExistsAtPath(path: String) -> Bool {
        return fileManager.fileExistsAtPath(path)
    }
    
    /**
     判断在指定的路径是否存在文件或者目录。isDirectory 指示了是文件或者目录。
     
     - parameter path:        指定路径
     - parameter isDirectory: 指示了是文件或者是目录
     
     - returns: Bool 值标示文件或目录是否存在；true存在，false不存在。
     */
    public class func fileExistsAtPath(path: String, isDirectory: UnsafeMutablePointer<ObjCBool>) -> Bool {
        return fileManager.fileExistsAtPath(path, isDirectory: isDirectory)
    }
    
    /**
     删除文件、目录
     
     - parameter path: 文件路径
     
     - throws: 抛出错误
     */
    public class func removeItemAtPath(path: String) throws {
        guard fileExistsAtPath(path) else {
            return
        }
        try fileManager.removeItemAtPath(path)
    }
    
    /**
     创建目录
     
     - parameter path: 文件路径
     
     - throws: 抛出错误
     */
    public class func createDirectoryAt(path: String) throws {
        try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /**
     创建文件，创建成功或者已经存在时返回 true，否则返回 false。
     
     - parameter path:        文件路径
     - parameter fileContent: 文件内容
     
     - returns: 创建文件是否成功
     */
    public class func createFileAt(path: String, fileContent: NSData?, attributes: [String : AnyObject]?) -> Bool {
        return fileManager.createFileAtPath(path, contents: fileContent, attributes: attributes)
    }
    
    /**
     获取文件或者目录，返回一个元组，
     
     - parameter path: 目录
     
     - throws: 抛出错误
     
     - returns: (files: 文件数组, directories: 目录数组)
     */
    public class func contentsOfDirectoryAt(path: String) throws -> (files: [String], directories: [String]) {
        var files: [String] = []
        var directories: [String] = []
        let items = try fileManager.contentsOfDirectoryAtPath(path)
        for item in items {
            let itemPath = (path as NSString).stringByAppendingPathComponent(item)
            var isDir = ObjCBool(false)
            fileManager.fileExistsAtPath(itemPath, isDirectory: &isDir)
            if isDir {
                directories.append(item)
            } else {
                files.append(item)
            }
        }
        return (files, directories)
    }
    
    /**
     将位于 location 的文件拷贝到 destination，会覆盖。
     
     - parameter location:    location NSURL
     - parameter destination: destination NSURL
     
     - throws: 抛出错误
     
     - returns: 目标文件的 NSURL
     */
    public class func copyItemAtURL(location: NSURL, destination: NSURL) throws {
        //        let destinationURL = destination.URLByAppendingPathComponent(location.lastPathComponent!)
        if let destinationPath = destination.path where fileManager.fileExistsAtPath(destinationPath) {
            try fileManager.removeItemAtPath(destinationPath)
        }
        try fileManager.copyItemAtURL(location, toURL: destination)
    }
    
    /**
     返回文件大小，单位为 bytes。
     
     - parameter filePath: 文件路径
     
     - throws: 抛出错误
     
     - returns: 大小，bytes表示。
     */
    public class func fileSizeAtPath(filePath: String) throws -> UInt {
        if fileManager.fileExistsAtPath(filePath) {
            let size = try fileManager.attributesOfItemAtPath(filePath)[NSFileSize]
            if let size = size as? NSNumber {
                return size.unsignedIntegerValue
            }
        }
        return 0
    }
    
    /**
     返回文件夹中所有文件的个数(包括子目录中的文件)和总的大小。
     
     - parameter folderPath: 文件夹路径
     
     - throws: 抛出错误
     
     - returns: (fileCount: UInt, totalSize: UInt)
     */
    public class func folderSizeAtPath(folderPath: String) throws -> (fileCount: UInt, totalSize: UInt) {
        let folderURL = NSURL(fileURLWithPath: folderPath, isDirectory: true)
        
        var fileCount: UInt = 0
        var totalSize: UInt = 0
        
        let fileEnumerator = fileManager.enumeratorAtURL(folderURL,
                                                         includingPropertiesForKeys: [NSFileSize],
                                                         options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
                                                         errorHandler: nil)!
        
        for fileURL in fileEnumerator {
            if let fileURL = fileURL as? NSURL {
                var fileSize: AnyObject?
                try fileURL.getResourceValue(&fileSize, forKey: NSURLFileSizeKey)
                if let fileSize = fileSize as? NSNumber {
                    totalSize += fileSize.unsignedIntegerValue
                    fileCount += 1
                }
            }
        }
        return (fileCount, totalSize)
    }

}