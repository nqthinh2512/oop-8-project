import QtQuick
import src
import QtQuick.Layouts

Rectangle {
    id: root

    property string titleText: "MONTHLY INCOME"
    property string amountText: "1,000 VND"
    property string labelText: "July 2026"
    property string subtitleText: "+4.2% vs June"
    property color subtitleColor: "#6366f1"

    implicitHeight: 140
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    clip: true

    readonly property bool isPercentage: /^\s*\d+(\.\d+)?%\s*$/.test(amountText)
    readonly property real targetPercentValue: isPercentage ? parseFloat(amountText) : 0

    property real animatedPercentValue: 0

    function startProgressAnimation() {
        if (root.isPercentage) {
            progressAnim.stop()
            root.animatedPercentValue = 0
            progressAnim.start()
        }
    }

    Component.onCompleted: startProgressAnimation()
    onVisibleChanged: {
        if (visible) startProgressAnimation()
    }
    onTargetPercentValueChanged: startProgressAnimation()

    NumberAnimation on animatedPercentValue {
        id: progressAnim
        running: false
        from: 0
        to: root.targetPercentValue
        duration: 800
        easing.type: Easing.OutCubic
    }

    color: AppTheme.bgCard
    border.color: AppTheme.border
    border.width: 1
    radius: 12

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 6

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            // anchors.margins: left

            // Card Title
            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: AppTheme.textSub
                text: root.titleText.toUpperCase()
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Amount & Label
            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: AppTheme.textMain
                text: root.amountText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                font.family: "Inter"
                font.pixelSize: 12
                color: AppTheme.textSub
                text: root.labelText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            // Subtitle / Trend
            Text {
                font.family: "Inter"
                font.pixelSize: 11
                font.weight: Font.Medium
                color: root.subtitleColor
                text: root.subtitleText
                elide: Text.ElideRight
                visible: root.subtitleText.length > 0
                Layout.fillWidth: true
            }
        }

        Canvas {
            id: progressCanvas

            visible: root.isPercentage
            Layout.preferredWidth: visible ? 64 : 0
            Layout.preferredHeight: 64
            Layout.rightMargin: 5
            Layout.alignment: Qt.AlignVCenter

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                if (!visible) return;

                var x = width / 2;
                var y = height / 2;
                var radius = Math.min(width, height) / 2 - 4;
                var lineWidth = 6;

                ctx.beginPath();
                ctx.arc(x, y, radius, 0, 2 * Math.PI, false);
                ctx.lineWidth = lineWidth;
                ctx.strokeStyle = AppTheme.border;
                ctx.stroke();

                var startAngle = -Math.PI / 2;
                var progress = Math.min(Math.max(root.animatedPercentValue / 100, 0), 1);
                var endAngle = startAngle + (progress * 2 * Math.PI);

                if (progress > 0) {
                    ctx.beginPath();
                    ctx.arc(x, y, radius, startAngle, endAngle, false);
                    ctx.lineWidth = lineWidth;
                    ctx.strokeStyle = "#10b981";
                    ctx.lineCap = "round";
                    ctx.stroke();
                }
            }

            Connections {
                target: root
                function onAnimatedPercentValueChanged() {
                    progressCanvas.requestPaint();
                }
            }
        }
    }
}
