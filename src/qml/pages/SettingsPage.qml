import QtQuick
import src
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

Rectangle {
    id: settingsPage
    height: 1117
    width: 1728
    clip: true
    color: AppTheme.bgApp

    FolderDialog {
        id: exportFolderDialog
        title: "Select Folder to Export All CSV Data"
        currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
        onAccepted: {
            var dateStr = new Date().toISOString().replace(/[:\-\.]/g, "").substring(0, 14);
            var targetDir = selectedFolder.toString() + "/Finance_Export_" + dateStr;
            settingsController.exportAllToCSV(targetDir)
        }
    }

    property bool isEditing: settingsController.isEditing

    // Profile Data (Current Input State)
    property string currentFullName: settingsController.fullName
    property string currentEmail: settingsController.email
    property string currentContact: settingsController.contact

        // Sync input state when edit mode is activated/canceled
    Connections {
        target: settingsController
        function onIsEditingChanged() {
            if (settingsController.isEditing) {
                currentFullName = settingsController.fullName;
                currentEmail = settingsController.email;
                currentContact = settingsController.contact;
            } else {
                            }
        }
    }

    // If page is hidden (navigated away), reset state
    onVisibleChanged: {
        if (!visible && isEditing) {
            settingsController.cancelEdit();
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: scrollView.width - 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            spacing: 24

            // =================================================================
            // 1. PAGE HEADER TITLE & DIVIDER
            // =================================================================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    text: "Profile & Settings"
                    font.family: "Inter"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: AppTheme.border
                }
            }

            // =================================================================
            // 1.5 ACTION BAR (Edit Profile)
            // =================================================================
            RowLayout {
                Layout.fillWidth: true
                
                Item { Layout.fillWidth: true } // Push button to right
                
                UniversalButton_1 {
                    buttonText: isEditing ? "Cancel Edit" : "Edit Profile"
                    _state: UniversalButton_1.State_1.State_1_selected
                    onClicked: {
                        settingsController.toggleEdit();
                    }
                }
            }

            // =================================================================
            // 2. PROFILE INFORMATION CARD
            // =================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: profileInfoCol.implicitHeight + 48
                radius: 12
                color: AppTheme.bgCard
                border.color: AppTheme.border
                border.width: 1
                
                ColumnLayout {
                    id: profileInfoCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 24
                    spacing: 24

                    // Card Header
                    Text {
                        text: "Profile Information"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: AppTheme.textMain
                    }

                    // =========================================================
                    // AVATAR (circular photo or colored initials placeholder)
                    // =========================================================
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        Rectangle {
                            id: avatarCircle
                            width: 84
                            height: 84
                            radius: 42
                            color: settingsController.avatarColor
                            border.color: AppTheme.border
                            border.width: 1
                            clip: true

                            Image {
                                id: avatarImage
                                anchors.fill: parent
                                source: settingsController.avatarImagePath
                                visible: settingsController.avatarImagePath !== ""
                                fillMode: Image.PreserveAspectCrop
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: settingsController.avatarImagePath === ""
                                text: settingsController.initials
                                color: AppTheme.bgCard
                                font.family: "Inter"
                                font.pixelSize: 30
                                font.weight: Font.Bold
                            }
                        }

                        ColumnLayout {
                            spacing: 6

                            Rectangle {
                                width: 160
                                height: 38
                                radius: 6
                                color: AppTheme.bgHover
                                border.color: AppTheme.border
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: "Change your avatar"
                                    color: AppTheme.textMain
                                    font.family: "Inter"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: avatarPickerPopup.open()
                                }
                            }

                            Text {
                                text: "PNG or JPG, or pick a preset color"
                                color: AppTheme.textMuted
                                font.family: "Inter"
                                font.pixelSize: 12
                            }
                        }
                    }

                    // Avatar picker popup: upload from device OR choose a preset color
                    Popup {
                        id: avatarPickerPopup
                        anchors.centerIn: Overlay.overlay
                        width: 340
                        modal: true
                        focus: true
                        padding: 20
                        background: Rectangle {
                            color: AppTheme.bgCard
                            radius: 12
                            border.color: AppTheme.border
                            border.width: 1
                        }

                        ColumnLayout {
                            width: parent.width
                            spacing: 16

                            Text {
                                text: "Change Avatar"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: AppTheme.textMain
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: AppTheme.primary

                                Text {
                                    anchors.centerIn: parent
                                    text: "Upload From This Device"
                                    color: AppTheme.bgCard
                                    font.family: "Inter"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: avatarFileDialog.open()
                                }
                            }

                            Text {
                                text: "Or pick a preset"
                                font.family: "Inter"
                                font.pixelSize: 13
                                color: AppTheme.textSub
                            }

                            GridLayout {
                                Layout.fillWidth: true
                                columns: 6
                                rowSpacing: 10
                                columnSpacing: 10

                                Repeater {
                                    model: ["#3b82f6", "#ef4444", "#10b981", "#f59e0b", "#8b5cf6", "#ec4899",
                                            "#06b6d4", "#84cc16", "#f97316", "#6366f1", "#14b8a6", "#64748b"]

                                    Rectangle {
                                        width: 36
                                        height: 36
                                        radius: 18
                                        color: modelData
                                        border.width: settingsController.avatarColor === modelData && settingsController.avatarImagePath === "" ? 3 : 0
                                        border.color: AppTheme.textMain

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                settingsController.setAvatarPreset(modelData)
                                                avatarPickerPopup.close()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    FileDialog {
                        id: avatarFileDialog
                        title: "Choose an avatar photo"
                        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
                        onAccepted: {
                            settingsController.setAvatarImage(selectedFile.toString())
                            avatarPickerPopup.close()
                        }
                    }

                    // Profile Details Grid
                    GridLayout {
                        columns: 2
                        columnSpacing: 100
                        rowSpacing: 24
                        Layout.fillWidth: true

                        // --- Row 1 ---
                        // Full Name (Editable)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Text { text: "Full Name"; font.pixelSize: 14; color: AppTheme.textSub; font.family: "Inter" }
                            Text { 
                                text: settingsController.fullName; font.pixelSize: 16; color: AppTheme.textMain; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: AppTheme.bgApp
                                border.color: AppTheme.border
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: AppTheme.textMain
                                    text: currentFullName
                                    onTextChanged: currentFullName = text
                                }
                            }
                        }

                        // --- Row 2 ---
                        // Email (Editable)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Text { text: "Email"; font.pixelSize: 14; color: AppTheme.textSub; font.family: "Inter" }
                            Text { 
                                text: settingsController.email; font.pixelSize: 16; color: AppTheme.textMain; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: AppTheme.bgApp
                                border.color: AppTheme.border
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: AppTheme.textMain
                                    text: currentEmail
                                    onTextChanged: currentEmail = text
                                }
                            }
                        }
                        // Contact Number (Editable)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Text { text: "Contact Number"; font.pixelSize: 14; color: AppTheme.textSub; font.family: "Inter" }
                            Text { 
                                text: settingsController.contact; font.pixelSize: 16; color: AppTheme.textMain; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: AppTheme.bgApp
                                border.color: AppTheme.border
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: AppTheme.textMain
                                    text: currentContact
                                    onTextChanged: currentContact = text
                                }
                            }
                        }

                        
                    }
                }
            }

            // =================================================================
            // 4. PREFERENCES CARD
            // =================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: prefsCol.implicitHeight + 48
                radius: 12
                color: AppTheme.bgCard
                border.color: AppTheme.border
                border.width: 1

                ColumnLayout {
                    id: prefsCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 24
                    spacing: 24

                    Text {
                        text: "Preferences"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: AppTheme.textMain
                    }

                    // Theme
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Theme"
                            font.family: "Inter"
                            font.pixelSize: 14
                            color: AppTheme.textMain
                            font.weight: Font.Medium
                            Layout.preferredWidth: 200
                        }
                        Dropdown_1 {
                            Layout.preferredWidth: 200
                            model: ["Light", "Dark"]
                            selectedIndex: settingsController.theme === "Dark" ? 1 : 0
                            selectedText: settingsController.theme
                            onSelected: function(index, value) {
                                settingsController.theme = value;
                            }
                        }
                        Item { Layout.fillWidth: true }
                    }

                    // Auto Backup
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Auto-Backup on Exit"
                            font.family: "Inter"
                            font.pixelSize: 14
                            color: AppTheme.textMain
                            font.weight: Font.Medium
                            Layout.preferredWidth: 200
                        }
                        ToggleSwitch_1 {
                            checked: settingsController.autoBackup
                            onToggled: function(val) { settingsController.autoBackup = val }
                        }
                        Item { Layout.fillWidth: true }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: AppTheme.border }

                    // Factory Reset
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Text {
                                text: "Factory Reset"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                color: AppTheme.danger
                            }
                            Text {
                                text: "Permanently delete all your data and reset the app. This cannot be undone."
                                font.family: "Inter"
                                font.pixelSize: 12
                                color: AppTheme.textSub
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                        UniversalButton_1 {
                            buttonText: "Reset App"
                            _state: UniversalButton_1.State_1.State_1_default
                            onClicked: settingsController.factoryReset()
                        }
                    }
                }
            }

            // =================================================================
            // 5. DATA EXPORT CARD
            // =================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: exportCol.implicitHeight + 48
                radius: 12
                color: AppTheme.bgCard
                border.color: AppTheme.border
                border.width: 1

                ColumnLayout {
                    id: exportCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Data Export & Backup"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: AppTheme.textMain
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            Layout.fillWidth: true
                            text: "Export all your financial records (categories, transactions, bills, budgets, savings) to CSV files."
                            font.family: "Inter"
                            font.pixelSize: 14
                            color: AppTheme.textSub
                            elide: Text.ElideRight
                        }

                        UniversalButton_1 {
                            buttonText: "Export All Data (CSV)"
                            _state: UniversalButton_1.State_1.State_1_selected
                            onClicked: exportFolderDialog.open()
                        }
                    }
                }
            }

            // =================================================================
            Item {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 32
            }
        }
    }
}
