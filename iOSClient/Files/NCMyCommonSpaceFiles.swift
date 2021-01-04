//
//  NCMyCommonSpaceFiles.swift
//  Nextcloud
//
//  Created by cc2 on 2020/12/12.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//

import Foundation
//mport NCCommunication

class NCMyCommonSpaceFiles: NCCollectionViewCommon  {
    
    internal var isRoot: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isCommonSpace = true
//        appDelegate.activeFiles = self
        titleCurrentFolder = "文件"
        layoutKey = k_layout_view_files
        enableSearchBar = true
        emptyImage = CCGraphics.changeThemingColorImage(UIImage.init(named: "folder"), width: 300, height: 300, color: NCBrandColor.sharedInstance.brandElement)
        emptyTitle = "_files_no_files_"
        emptyDescription = "_no_file_pull_down_"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isRoot {
            serverUrl = NCUtility.shared.getHomeServer(urlBase: appDelegate.urlBase, account: appDelegate.account)
        }
        
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = nil


    }
    
    // MARK: - NotificationCenter
    
    override func initializeMain() {
        
        if isRoot {
            serverUrl = NCUtility.shared.getHomeServer(urlBase: appDelegate.urlBase, account: appDelegate.account)
            reloadDataSourceNetwork(forced: true)
        }
        
        super.initializeMain()
    }
    
    // MARK: - DataSource + NC Endpoint
    
    override func reloadDataSource() {
        super.reloadDataSource()
        
        DispatchQueue.global().async {
                        
            if !self.isSearching {
                self.metadatasSource = NCManageDatabase.sharedInstance.getMetadatas(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@", self.appDelegate.account, self.serverUrl))
                if self.metadataFolder == nil {
                    self.metadataFolder = NCManageDatabase.sharedInstance.getMetadataFolder(account: self.appDelegate.account, urlBase: self.appDelegate.urlBase, serverUrl:  self.serverUrl)
                }
            }
            
            self.dataSource = NCDataSource.init(metadatasSource: self.metadatasSource, sort: self.sort, ascending: self.ascending, directoryOnTop: self.directoryOnTop, favoriteOnTop: true, filterLivePhoto: true)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func reloadDataSourceNetwork(forced: Bool = false) {
        super.reloadDataSourceNetwork(forced: forced)
        
        if isSearching {
            networkSearch()
            return
        }
        
        isReloadDataSourceNetworkInProgress = true
        collectionView?.reloadData()

        networkReadFolder(forced: forced) { (metadatas, metadatasUpdate, errorCode, errorDescription) in
            if errorCode == 0 {
                for metadata in metadatas ?? [] {
                    if !metadata.directory {
                        let localFile = NCManageDatabase.sharedInstance.getTableLocalFile(predicate: NSPredicate(format: "ocId == %@", metadata.ocId))
                        if (CCUtility.getFavoriteOffline() && localFile == nil) || (localFile != nil && localFile?.etag != metadata.etag) {
                            NCOperationQueue.shared.download(metadata: metadata, selector: selectorDownloadFile, setFavorite: false, forceDownload: true)
                        }
                    }
                }
            }

            self.refreshControl.endRefreshing()
            self.isReloadDataSourceNetworkInProgress = false
            if metadatasUpdate?.count ?? 0 > 0 || forced {
                self.reloadDataSource()
            } else {
                self.collectionView?.reloadData()
            }
        }
    }
}

