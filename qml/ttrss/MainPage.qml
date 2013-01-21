//Copyright Hauke Schade, 2012
//
//This file is part of TTRss.
//
//TTRss is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
//Free Software Foundation, either version 2 of the License, or (at your option) any later version.
//TTRss is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//You should have received a copy of the GNU General Public License along with TTRss (on a Maemo/Meego system there is a copy
//in /usr/share/common-licenses. If not, see http://www.gnu.org/licenses/.

import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property bool loading: false

    tools: commonTools

    state: (screen.currentOrientation === Screen.Portrait) ? "portrait" : "landscape"

    states: [
        State {
            name: "landscape"
            PropertyChanges {
                target: logo
                anchors.leftMargin: 50
                anchors.bottomMargin: 50
            }
            AnchorChanges {
                target: logo
                anchors {
                    bottom: undefined
                    horizontalCenter: undefined

                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            AnchorChanges {
                target: loginBox
                anchors {
                    bottom: undefined
                    horizontalCenter: undefined

                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
            PropertyChanges {
                target: loginBox
                width: 400
                anchors.rightMargin: 50
            }
        },
        State {
            name: "portrait"
            AnchorChanges {
                target: logo
                anchors {
                    left: undefined
                    verticalCenter: undefined

                    bottom: loginBox.top
                    horizontalCenter: parent.horizontalCenter
                }
            }
            AnchorChanges {
                target: loginBox
                anchors {
                    right: undefined
                    verticalCenter: undefined

                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
            PropertyChanges {
                target: loginBox
                width: 350
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: 500 }
    }

    Column {
        id: logo
        anchors {
            bottom: loginBox.top
            bottomMargin:  50
        }

        Image {
            width: 256
            height: 256
            source: "resources/ttrss256.png"
        }
    }

    Column {
        id: loginBox
        width: 350
        anchors {
            bottom: parent.bottom
            bottomMargin:  50
        }

        Label {
            id: serverLabel
            text: qsTr("Server:")
            width: parent.width
        }
        TextField {
            id: server
            text: ""
            width: parent.width
            enabled: !loading
        }
        Label {
            id: usernameLabel
            text: qsTr("Username:")
            width: parent.width
        }
        TextField {
            id: username
            text: ""
            width: parent.width
            enabled: !loading
        }
        Label {
            id: passwordLabel
            text: qsTr("Password:")
            width: parent.width
        }
        TextField {
            id: password
            echoMode: TextInput.PasswordEchoOnEdit
            width: parent.width
            enabled: !loading
        }
    }
    BusyIndicator {
        id: busyindicator1
        visible: loading
        running: loading
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        platformStyle: BusyIndicatorStyle { size: 'large' }
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolButton {
            id: loginButton
            text: qsTr("Login")
            anchors.right: menuButton.left
            onClicked: {
                var settings = rootWindow.settingsObject();
                settings.set("server", server.text);
                settings.set("username", username.text);
                settings.set("password", password.text);

                startLogin();
            }
            enabled: !loading
        }
        ToolIcon {
            id: menuButton
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            enabled: !loading
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            AboutItem {}
        }
    }

    function enableLoginBox(focus) {
        if(focus) {
            password.forceActiveFocus();
        }
    }

    function startLogin() {
        // close the menu
        if (myMenu.status !== DialogStatus.Closed)
            myMenu.close()

        //Start the loading anim
        loading = true;

        var ttrss = rootWindow.getTTRSS();
        ttrss.clearState();
        ttrss.setLoginDetails(username.text, password.text, server.text);
        ttrss.login(feedTreeCreated);
    }

    function feedTreeCreated(retcode, text) {
        var settings = rootWindow.settingsObject();

        //stop the loading anim
        loading = false;

        if(retcode) {
            //login failed....don't autlogin
            settings.set("dologin", "false");

            //Let the user know
            loginErrorDialog.text = text;
            loginErrorDialog.open();
        } else {
            //Login succeeded, auto login next Time
            settings.set("dologin", "true");

            //Now show the categories View
            rootWindow.openFile('Categories.qml');
        }
    }

    //Dialog for login errors
    ErrorDialog {
        id: loginErrorDialog
        text: "pageTitle"
    }

    Component.onCompleted: {
        var settings = rootWindow.settingsObject();
        settings.initialize();
        server.text = settings.get("server", "http://");
        username.text = settings.get("username", "");
        password.text = settings.get("password", "");
        var dologin = settings.get("dologin", "false");

        if(dologin === "true")
            startLogin();
    }
}