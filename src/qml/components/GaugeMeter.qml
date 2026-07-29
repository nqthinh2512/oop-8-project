import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property real currentValue: 12500
    property real maxValue: 20000
    property color trackColor: "#e5e7eb"
    property color progressColor: "#0284c7"
    property string minLabel: "$0"
    property string currentLabel: "12K"
    property string maxLabel: "$20k"

    implicitWidth: 160
    implicitHeight: 100

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centerX = width / 2;
            var centerY = height - 20;
            var radius = Math.min(centerX - 10, centerY - 10);
            var lineWidth = 12;

            if (radius <= 0) return;

            // Background Arc (180deg to 0deg)
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, Math.PI, 0, false);
            ctx.lineWidth = lineWidth;
            ctx.strokeStyle = root.trackColor;
            ctx.lineCap = "round";
            ctx.stroke();

            // Progress Arc
            var fraction = Math.min(Math.max(root.currentValue / (root.maxValue || 1), 0), 1);
            if (fraction > 0) {
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, Math.PI, Math.PI + fraction * Math.PI, false);
                ctx.lineWidth = lineWidth;
                ctx.strokeStyle = root.progressColor;
                ctx.lineCap = "round";
                ctx.stroke();
            }
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // Min label ($0)
    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: root.minLabel
        font.family: "Inter"
        font.pixelSize: 11
        color: "#9ca3af"
    }

    // Current value label (12K)
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: root.currentLabel
        font.family: "Inter"
        font.pixelSize: 13
        font.weight: Font.Bold
        color: "#191919"
    }

    // Max label ($20k)
    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: root.maxLabel
        font.family: "Inter"
        font.pixelSize: 11
        color: "#9ca3af"
    }

    Connections {
        target: root
        function onCurrentValueChanged() { canvas.requestPaint(); }
        function onMaxValueChanged() { canvas.requestPaint(); }
        function onProgressColorChanged() { canvas.requestPaint(); }
    }
}
