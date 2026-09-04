import QtQuick
import QtQuick.Controls
import Quickshell

ShellRoot {
    PanelWindow {
        anchors {
            bottom: true
            left: true
            right: true
        }

        implicitHeight: 70

        color: "transparent"

        Rectangle {
            anchors.centerIn: parent
            width: 300
            height: 60
            radius: 15

            color: "#07111c"
            border.color: "#24506f"
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 12

                LauncherButton {
                    icon: ""
                    app: "kitty"
                }

                LauncherButton {
                    icon: "󰨞"
                    app: "code"
                }

                LauncherButton {
                    icon: ""
                    app: "google-chrome-stable"
                }

                LauncherButton {
                    icon: ""
                    app: "spotify"
                }
            }
        }
    }

    component LauncherButton: Rectangle {
        property string icon
        property string app

        width: 50
        height: 50
        radius: 12

        color: mouse.containsMouse ? "#173b55" : "#0d1e2e"

        Text {
            anchors.centerIn: parent

            text: icon
            color: "white"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 25
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                Quickshell.execDetached([app])
            }
        }
    }
}