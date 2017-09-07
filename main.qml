import QtQuick 2.7
import QtQuick.Controls 2.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.0

import io.qt.examples.backend 1.0

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 800
    height: 600
    title: qsTr("Hello World")

    BackEnd {
        id: backend
    }

    function fullScreen(isFullScreen) {
        if (isFullScreen === true) {
            rectangleBottom.visible = false
            rectangleVideo.anchors.fill = rectangleVideo.parent
            rectangleVideo.focus = true
            showFullScreen()
        } else {
            rectangleVideo.anchors.fill = undefined
            rectangleVideo.anchors.bottom = rectangleBottom.top
            rectangleBottom.visible = true
            rectangleVideo.focus = false
            show()
        }
    }

    MediaPlayer {
        id: player
        source: backend.moviePath + "/TestVideo.mp4"
        onPositionChanged: {
            textPositionInDuration.text = position + "/" + duration
            sliderPosition.value = position
        }
        onError: console.log("MediaPlayer error!" + errorString + "(" + error + ")")
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
        property alias brightness: brightnessAndContrast.brightness
        property alias contrast: brightnessAndContrast.contrast
        property alias videoOutput: output

        VideoOutput {
            id: output
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            source: player
        }

        BrightnessContrast {
            id: brightnessAndContrast
            anchors.fill: parent
            source: output

        }

        MouseArea {
            id: mouseAreaVideo
            anchors.fill: parent
            onDoubleClicked: {
                if (applicationWindow.visibility == 5) {
                    fullScreen(false)
                } else {
                    fullScreen(true)
                }
            }
        }

        Keys.onPressed: {
            if (applicationWindow.visibility == 5 && event.key === Qt.Key_Escape) {
                fullScreen(false)
            }
        }
    }

    Rectangle {
        id: rectangleBottom
        y: 272
        height: 300
        color: "#ffffff"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom

        Row {
            id: row
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            clip: false

            Button {
                id: buttonPlay
                text: qsTr("Play")
                anchors.top: parent.top
                anchors.topMargin: 0
                onClicked: {
                    buttonPause.enabled = true
                    enabled = false
                    buttonStop.enabled = true
                    buttonMute.enabled = true
                    sliderPosition.to = player.duration
                    player.volume = sliderVolume.position
                    player.play()
                }
            }

            Button {
                id: buttonPause
                text: qsTr("Pause")
                anchors.top: parent.top
                anchors.topMargin: 0
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
                anchors.top: parent.top
                anchors.topMargin: 0
                enabled: false
                onClicked: {
                    buttonPlay.enabled = true
                    buttonPause.enabled = false
                    enabled = false
                    player.stop()
                }
            }

            Button {
                id: buttonMute
                text: qsTr("Mute")
                anchors.top: parent.top
                anchors.topMargin: 0
                checked: false
                checkable: true
                onClicked: player.muted = checked
            }

            Button {
                id: buttonFullScreen
                text: qsTr("FullScreen")
                onClicked: fullScreen(true)
            }
        }

        Text {
            id: textPositionInDuration
            y: 75
            text: qsTr("")
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
        }

        Slider {
            id: sliderPlaybackRate
            y: 53
            from: 0.01
            to: 4.0
            anchors.right: buttonResetPlaybackRate.left
            anchors.verticalCenter: buttonResetPlaybackRate.verticalCenter
            anchors.left: textPlaybackRate.right
            value: 1.0
            onVisualPositionChanged: {
                player.seek(sliderPosition.value)
                player.playbackRate = value
            }
        }

        Text {
            id: textPlaybackRate
            y: 64
            text: qsTr("PlaybackRate: ")
            anchors.verticalCenter: sliderPlaybackRate.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Button {
            id: buttonResetPlaybackRate
            x: 385
            text: qsTr("Reset")
            anchors.right: parent.right
            anchors.top: row.bottom
            onClicked: {
                sliderPlaybackRate.value = 1.0
            }
        }

        Slider {
            id: sliderPosition
            anchors.top: buttonResetPlaybackRate.bottom
            anchors.left: textPosition.right
            anchors.right: parent.right
            value: 0
            onPositionChanged: player.seek(value)
        }

        Text {
            id: textPosition
            x: 23
            y: 75
            text: "Position: "
            anchors.verticalCenter: sliderPosition.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Text {
            id: textVolume
            y: 125
            text: qsTr("Volume: ")
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Slider {
            id: sliderVolume
            anchors.left: textVolume.right
            anchors.right: parent.right
            anchors.top: sliderPosition.bottom
            value: 0.5
            onPositionChanged: player.volume = value
        }

        Text {
            id: textBrightness
            y: 183
            text: qsTr("Brightness: ")
            anchors.verticalCenter: sliderBrightness.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Slider {
            id: sliderBrightness
            y: 190
            anchors.right: buttonResetBrightness.left
            anchors.verticalCenter: buttonResetBrightness.verticalCenter
            from: -1
            anchors.left: textBrightness.right
            value: 0
            onPositionChanged: rectangleVideo.brightness = value
        }

        Button {
            id: buttonResetBrightness
            x: 403
            text: qsTr("Reset")
            anchors.right: parent.right
            anchors.top: sliderVolume.bottom
            onClicked: sliderBrightness.value = 0.0;
        }

        Text {
            id: textContrast
            y: 233
            text: qsTr("Contrast: ")
            anchors.verticalCenter: sliderContrast.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Slider {
            id: sliderContrast
            y: 241
            anchors.right: buttonResetContrast.left
            anchors.verticalCenter: buttonResetContrast.verticalCenter
            anchors.left: textContrast.right
            from: -1
            value: 0
            onPositionChanged: rectangleVideo.contrast = value
        }

        Button {
            id: buttonResetContrast
            x: 399
            text: qsTr("Reset")
            anchors.top: sliderBrightness.bottom
            anchors.right: parent.right
            onClicked: {
                sliderContrast.value = 0.0
            }
        }

        Text {
            id: textRotation
            y: 262
            text: qsTr("Rotation: ")
            anchors.verticalCenter: sliderRotation.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Slider {
            id: sliderRotation
            anchors.top: buttonResetContrast.bottom
            anchors.right: parent.right
            anchors.left: textRotation.right
            to: 360
            value: 0
            onPositionChanged: rectangleVideo.rotation = value
        }
    }
}
