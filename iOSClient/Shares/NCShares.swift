//
//  NCShares.swift
//  Nextcloud
//
//  Created by Marino Faggiana on 20/10/2020.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
//mport NCCommunication

class NCShares: NCCollectionViewCommon  {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        appDelegate.activeShares = self
        titleCurrentFolder = NSLocalizedString("_list_shares_", comment: "")
        layoutKey = k_layout_view_shares
        enableSearchBar = false
        emptyImage = CCGraphics.changeThemingColorImage(UIImage.init(named: "share"), width: 300, height: 300, color: .gray)
        emptyTitle = "_list_shares_no_files_"
        emptyDescription = "_tutorial_list_shares_view_"
    }
    
    // MARK: - DataSource + NC Endpoint
    
    func reloadTwoDataSource() {
        super.reloadDataSource()
        DispatchQueue.global().async {
            self.metadatasSource.removeAll()
            let sharess = NCManageDatabase.sharedInstance.getTableShares(account: self.appDelegate.account)
            for share in sharess {
                if let metadata = NCManageDatabase.sharedInstance.getMetadata(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@ AND fileName == %@", self.appDelegate.account, share.serverUrl, share.fileName)) {
                    self.metadatasSource.append(metadata)
                }
            }
            
            self.dataSource = NCDataSource.init(metadatasSource: self.metadatasSource, sort:self.sort, ascending: self.ascending, directoryOnTop: self.directoryOnTop, favoriteOnTop: true, filterLivePhoto: true)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func reloadDataSource() {
        super.reloadDataSource()
        
        if self.shareSpaceType == 1 {
            
        } else if self.shareSpaceType == 2 {
            
        } else if self.shareSpaceType == 3 {
            
        } else {
            DispatchQueue.global().async {
                self.metadatasSource.removeAll()
                let sharess = NCManageDatabase.sharedInstance.getTableShares(account: self.appDelegate.account)
                for share in sharess {
                    if let metadata = NCManageDatabase.sharedInstance.getMetadata(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@ AND fileName == %@", self.appDelegate.account, share.serverUrl, share.fileName)) {
                        self.metadatasSource.append(metadata)
                    }
                }
                
                self.dataSource = NCDataSource.init(metadatasSource: self.metadatasSource, sort:self.sort, ascending: self.ascending, directoryOnTop: self.directoryOnTop, favoriteOnTop: true, filterLivePhoto: true)
                
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
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
        
        if shareSpaceType == 1 {
            NCCommunication.shared.readTwoShares(shared_with_me: true) { (account, shares, errorCode, ErrorDescription) in
                self.refreshControl.endRefreshing()
                self.isReloadDataSourceNetworkInProgress = false
                    
                if errorCode == 0 {
                        
                    NCManageDatabase.sharedInstance.deleteTableShare(account: account)
                    if shares != nil {
                        NCManageDatabase.sharedInstance.addShare(urlBase: self.appDelegate.urlBase, account: account, shares: shares!)
                    }
                    self.appDelegate.shares = NCManageDatabase.sharedInstance.getTableShares(account: account)
                        
                    self.reloadTwoDataSource()
                        
                } else {
                        
                    self.collectionView?.reloadData()
                    NCContentPresenter.shared.messageNotification("_share_", description: ErrorDescription, delay: TimeInterval(k_dismissAfterSecond), type: NCContentPresenter.messageType.error, errorCode: errorCode)
                }
            }

            
        } else if shareSpaceType == 2 {
            NCCommunication.shared.readTwoShares(shared_with_me: false) { (account, shares, errorCode, ErrorDescription) in
                self.refreshControl.endRefreshing()
                self.isReloadDataSourceNetworkInProgress = false
                    
                if errorCode == 0 {
                        
                    NCManageDatabase.sharedInstance.deleteTableShare(account: account)
                    if shares != nil {
                        NCManageDatabase.sharedInstance.addShare(urlBase: self.appDelegate.urlBase, account: account, shares: shares!)
                    }
                    self.appDelegate.shares = NCManageDatabase.sharedInstance.getTableShares(account: account)
                        
                    self.reloadTwoDataSource()
                        
                } else {
                        
                    self.collectionView?.reloadData()
                    NCContentPresenter.shared.messageNotification("_share_", description: ErrorDescription, delay: TimeInterval(k_dismissAfterSecond), type: NCContentPresenter.messageType.error, errorCode: errorCode)
                }
            }

            
        } else if shareSpaceType == 3 {
            NCCommunication.shared.readTwoShares(shared_with_me: false) { (account, shares, errorCode, ErrorDescription) in
                self.refreshControl.endRefreshing()
                self.isReloadDataSourceNetworkInProgress = false
                    
                if errorCode == 0 {
                       
                    NCManageDatabase.sharedInstance.deleteTableShare(account: account)
                    if shares != nil {
                        
                        var selectShares:[NCCommunicationShare] = []
                        for shareData in shares ?? [] {
                            if shareData.shareType == 3 {
                                selectShares.append(shareData)
                            }
                        }
                        NCManageDatabase.sharedInstance.addShare(urlBase: self.appDelegate.urlBase, account: account, shares: selectShares)
                    }
//                    self.appDelegate.shares = NCManageDatabase.sharedInstance.getTableShares(account: account)
                        
                    self.reloadTwoDataSource()
                        
                } else {
                        
                    self.collectionView?.reloadData()
                    NCContentPresenter.shared.messageNotification("_share_", description: ErrorDescription, delay: TimeInterval(k_dismissAfterSecond), type: NCContentPresenter.messageType.error, errorCode: errorCode)
                }
            }

            
        } else {
            // Shares network
            NCCommunication.shared.readShares { (account, shares, errorCode, ErrorDescription) in
                    
                self.refreshControl.endRefreshing()
                self.isReloadDataSourceNetworkInProgress = false
                    
                if errorCode == 0 {
                        
                    NCManageDatabase.sharedInstance.deleteTableShare(account: account)
                    if shares != nil {
                        NCManageDatabase.sharedInstance.addShare(urlBase: self.appDelegate.urlBase, account: account, shares: shares!)
                    }
                    self.appDelegate.shares = NCManageDatabase.sharedInstance.getTableShares(account: account)
                        
                    self.reloadDataSource()
                        
                } else {
                        
                    self.collectionView?.reloadData()
                    NCContentPresenter.shared.messageNotification("_share_", description: ErrorDescription, delay: TimeInterval(k_dismissAfterSecond), type: NCContentPresenter.messageType.error, errorCode: errorCode)
                }
            }
        }
                    
        
    }
}

