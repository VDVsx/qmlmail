/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.1
import com.nokia.meego 1.2
import com.nokia.extras 1.1
import org.nemomobile.email 0.1

Page {
    id: container

    signal topicTriggered(int index)
    property alias currentTopic: listView.currentIndex
    property alias interactive: listView.interactive
    property alias model: listView.model

    PageHeader {
        id: pageHeader
        color: "#0066ff"
        text: "Mail"

        BusyIndicator {
            visible: window.refreshInProgress
            running: window.refreshInProgress
            anchors.right: parent.right
            anchors.rightMargin: UiConstants.DefaultMargin
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ListView {
        id: listView
        anchors.top: pageHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        model: mailAccountListModel

        onCurrentIndexChanged: container.topicTriggered(currentIndex)

        delegate: MouseArea {
            id: accountItem
            width: parent.width
            height: UiConstants.ListItemHeightDefault

            //: Label that displays the number of unread e-mail messages.  Note plural handling.
            property string unreadMessagesLabel: qsTr("%n unread message(s)", "", unreadCount)

            property string accountDisplayName;
            accountDisplayName: {
                accountDisplayName = displayName;
                window.currentAccountDisplayName = displayName;
                if (index == 0)
                    window.currentMailAccountId = mailAccountId;
            }

            Image {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if (mailServer == "gmail") {
                        "icons/gmail.png"
                    } else if (mailServer == "msn" || mailServer == "hotmail") {
                        "icons/msmail.png"
                    } else {
                        "icons/generic.png"
                    }
                }
            }

            Text {
                id: accountName
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 100
                verticalAlignment: Text.AlignVCenter
                text: emailAddress + " - " + displayName  //i18n ok
            }

            CountBubble {
                id: unreadImage
                anchors.right: goToFolderListIcon.left 
                anchors.rightMargin:10 
                anchors.verticalCenter: parent.verticalCenter
                value: unreadCount
            }

            MoreIndicator {
                id: goToFolderListIcon
                anchors.right: parent.right
                anchors.rightMargin: UiConstants.DefaultMargin
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                listView.currentIndex = index;
                window.currentMailAccountId = mailAccountId;
                window.currentMailAccountIndex = index;
                window.currentAccountDisplayName = displayName;
                messageListModel.setAccountKey (mailAccountId);
                mailFolderListModel.setAccountKey(mailAccountId);
                window.folderListViewTitle = window.currentAccountDisplayName + " " + mailFolderListModel.inboxFolderName();
                window.currentFolderId = mailFolderListModel.inboxFolderId();
                window.currentFolderName = mailFolderListModel.inboxFolderName();
                pageStack.push(Qt.resolvedUrl("FolderListView.qml"))
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon { iconId: "icon-m-toolbar-refresh"; onClicked: {
            // TODO: a spinner in the PageHeader would be neat
            if (window.refreshInProgress == true) {
                emailAgent.cancelSync();
                window.refreshInProgress = false;
            } else {
                emailAgent.accountsSync();
                window.refreshInProgress = true;
            }
        } }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: colorMenu.open(); }
    }
}
