//
//  EPMediaViewController.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/2/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GCDWebServer

class EPMediaViewController: EPTableViewController {
    
    var dataSource = [EPMedia]()
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "视频"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(EPMediaViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)

        addItem.rx_tap
            .subscribeNext { [unowned self] () in
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.webUploader.delegate = self
                    appDelegate.webUploader.start()
                    print(appDelegate.webUploader.serverURL)
                    
                    let alertView = UIAlertView(title: "Wi-Fi上传", message: "在浏览器中访问 \(appDelegate.webUploader.serverURL) 上传视频，支持所有视频格式，上传时请勿点击取消。", delegate: self, cancelButtonTitle: "取消")
                    self.view.addSubview(alertView)
                    alertView.show()
                }
            }
            .addDisposableTo(disposeBag)
        
        loadData()
    }
    
    func loadData() {
        dispatch_async(dispatch_queue_create("Loading Media List", DISPATCH_QUEUE_SERIAL)) {
            
            var medias = [EPMedia]()
            
            let documentDirectory = FileUtils.documentDirectory
            let (files, _) = try! FileUtils.contentsOfDirectoryAt(documentDirectory)
            for mediaName in files {
                let path = (documentDirectory as NSString).stringByAppendingPathComponent(mediaName)
                let media = EPMedia(path: path)
                medias.append(media)
            }
            
            self.dataSource = medias
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                if let refreshControl = self.refreshControl where refreshControl.refreshing {
                    refreshControl.endRefreshing()
                }
            })
        }
    }

}

extension EPMediaViewController: GCDWebUploaderDelegate {

    func webUploader(uploader: GCDWebUploader!, didUploadFileAtPath path: String!) {
        print("didUploadFileAtPath")
        loadData()
    }
    
    func webUploader(uploader: GCDWebUploader!, didDeleteItemAtPath path: String!) {
        print("didDeleteItemAtPath")
        loadData()
    }

}

extension EPMediaViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "MediaCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? EPMediaTableViewCell
        if cell == nil {
            cell = EPMediaTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        cell?.configCell(dataSource[indexPath.row].media)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let playerView = UIViewController.initializeViewControllerWith("Main", storyboardId: "Player", controllerType: EPPlayerViewController.self)
        playerView.media = dataSource[indexPath.row].media
        navigationController?.presentViewController(playerView, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            do {
                try FileUtils.removeItemAtPath(dataSource[indexPath.row].path)
                loadData()
            } catch {
                print("删除失败！")
            }
        }
    }
    
}

extension EPMediaViewController: UIAlertViewDelegate {

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webUploader.stop()
    }
    
}
