import QtQuick 2.7
import QtQuick.Controls 2.0
import QtMultimedia 5.8

import io.qt.examples.backend 1.0

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    BackEnd {
        id: backend
    }

    MediaPlayer {
        id: player
        source: backend.moviePath + "/TestVideo.mp4"
    }

    Rectangle {
        id: rectangleVideo
        color: "#000000"
        anchors.bottom: rectangleBottom.top
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        border.width: 1

        VideoOutput {
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            source: player
        }
    }

    Rectangle {
        id: rectangleBottom
        y: 272
        height: 100
        color: "#ffffff"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom

        Row {
            id: row
            clip: false
            anchors.fill: parent

            Button {
                id: buttonPlay
                text: qsTr("Play")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    buttonPause.enabled = true
                    enabled = false
                    buttonStop.enabled = true
                    player.play()
                }
            }

            Button {
                id: buttonPause
                text: qsTr("Pause")
                anchors.verticalCenter: parent.verticalCenter
                enabled: false
                onClicked: {
                    buttonPlay.enabled = true
                    enabled = false
                    player.pause()
                }
            }

            Button {
                id: buttonStop
                text: qsTr("Stop")
                enabled: false
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    buttonPlay.enabled = true
                    buttonPause.enabled = false
                    enabled = false
                    player.stop()
                }
            }
        }
    }
}
