import QtQuick
import src
import QtQuick.Layouts

Item {
    id: root

    property real currentValue: 12500
    property real maxValue: 20000
    property color trackColor: AppTheme.isDark ? "#334155" : "#e5e7eb"
    property color progressColor: "#0284c7"
    property string minLabel: "0%"
    property string currentLabel: "50%"
    property string maxLabel: "100%"

    implicitWidth: 140
    implicitHeight: 90

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var w = width;
            var h = height;
            if (w <= 0 || h <= 0) return;

            var bottomPadding = 20;
            var centerX = w / 2;
            var centerY = h - bottomPadding;
            var radius = Math.min(centerX - 10, centerY - 10);
            var lineWidth = Math.max(6, Math.min(12, radius * 0.2));

            if (radius <= 5) return;

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

    // Min label (0%)
    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: root.minLabel
        font.family: "Inter"
        font.pixelSize: 11
        color: AppTheme.textMuted
    }

    // Current value label (50%)
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: root.currentLabel
        font.family: "Inter"
        font.pixelSize: 13
        font.weight: Font.Bold
        color: AppTheme.textMain
    }

    // Max label (100%)
    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: root.maxLabel
        font.family: "Inter"
        font.pixelSize: 11
        color: AppTheme.textMuted
    }

    Connections {
        target: root
        function onCurrentValueChanged() { canvas.requestPaint(); }
        function onMaxValueChanged() { canvas.requestPaint(); }
        function onProgressColorChanged() { canvas.requestPaint(); }
    }
}
