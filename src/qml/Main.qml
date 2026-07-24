// src/qml/Main.qml
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 600
    height: 400
    visible: true
    title: "Finance Dashboard - QML Test"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2d"

        Text {
            anchors.centerIn: parent
            text: "QML is Working!"
            color: "#ffffff"
            font.pixelSize: 24
            font.bold: true
        }
    }
}