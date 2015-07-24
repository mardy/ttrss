//Copyright Alberto Mardegan, 2015
//
//This file is part of TTRss.
//
//TTRss is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
//Free Software Foundation, either version 2 of the License, or (at your option) any later version.
//TTRss is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//You should have received a copy of the GNU General Public License along with TTRss (on a Maemo/Meego system there is a copy
//in /usr/share/common-licenses. If not, see http://www.gnu.org/licenses/.

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Content 1.1
import Ubuntu.DownloadManager 0.1

Page {
    id: root

    property string url: ""
    property alias contentType: picker.contentType

    title: picker.headerText

    Flickable {
        anchors.fill: parent
        contentHeight: picker.height

        ContentPeerPicker {
            id: picker
            showTitle: false
            handler: ContentHandler.Destination
            onPeerSelected: {
                console.log("Peer selected")
                singleDownload.download(root.url)
                var transfer = peer.request()
                transfer.downloadId = singleDownload.downloadId
                transfer.start()
            }
        }

        SingleDownload {
            id: singleDownload
        }
    }
}
