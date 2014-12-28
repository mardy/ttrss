//Copyright Hauke Schade, 2012-2014
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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Empty {
    id: listItem

    property int value

    SubtitledLabel {
        anchors.leftMargin: units.gu(1)
        anchors.right: countLabel.left
        iconSource: model.icon
        iconColor: settings.whiteBackgroundOnIcons ? "white" : undefined
        bold: model.unreadcount > 0
        text: model.title
    }

    Label {
        id: countLabel
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: model.unreadcount
        anchors.rightMargin: units.gu(1)
    }
}
