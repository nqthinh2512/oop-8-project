import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: settingsPage
    height: 1117
    width: 1728
    clip: true
    color: "#f8fafc"

    property bool isEditing: settingsController.isEditing

    // Profile Data (Current Input State)
    property string currentFullName: settingsController.fullName
    property string currentEmail: settingsController.email
    property string currentContact: settingsController.contact

    // Password State
    property bool showCurrentPwd: false
    property bool showNewPwd: false
    property bool showConfirmPwd: false

    // Sync input state when edit mode is activated/canceled
    Connections {
        target: settingsController
        function onIsEditingChanged() {
            if (settingsController.isEditing) {
                currentFullName = settingsController.fullName;
                currentEmail = settingsController.email;
                currentContact = settingsController.contact;
            } else {
                // Clear passwords when edit mode is exited
                currentPwdInput.text = "";
                newPwdInput.text = "";
                confirmPwdInput.text = "";
                showCurrentPwd = false;
                showNewPwd = false;
                showConfirmPwd = false;
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
                    color: "#0f172a"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#e2e8f0"
                }
            }

            // =================================================================
            // 1.5 ACTION BAR (Edit Profile)
            // =================================================================
            RowLayout {
                Layout.fillWidth: true
                
                Item { Layout.fillWidth: true } // Push button to right
                
                Rectangle {
                    width: 130
                    height: 42
                    radius: 6
                    color: "#3b82f6" // Project's blue color
                    
                    Text {
                        anchors.centerIn: parent
                        text: isEditing ? "Cancel Edit" : "Edit Profile"
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Medium
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            settingsController.toggleEdit();
                        }
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
                color: "white"
                border.color: "#e2e8f0"
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
                        color: "#0f172a"
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
                            Text { text: "Full Name"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { 
                                text: settingsController.fullName; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    text: currentFullName
                                    onTextChanged: currentFullName = text
                                }
                            }
                        }
                        // Employee ID (Read-only)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Text { text: "Employee ID"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { text: "EMP-2024-001"; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium }
                        }

                        // --- Row 2 ---
                        // Email (Editable)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Text { text: "Email"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { 
                                text: settingsController.email; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    text: currentEmail
                                    onTextChanged: currentEmail = text
                                }
                            }
                        }
                        // Contact Number (Editable)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Text { text: "Contact Number"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { 
                                text: settingsController.contact; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium 
                                visible: !isEditing
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                visible: isEditing
                                TextInput {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    text: currentContact
                                    onTextChanged: currentContact = text
                                }
                            }
                        }

                        // --- Row 3 ---
                        // Department (Read-only)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Text { text: "Department"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { text: "IT Department"; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium }
                        }
                        // Role (Read-only)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Text { text: "Role"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { text: "Administrator"; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium }
                        }

                        // --- Row 4 ---
                        // Account Type (Read-only)
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Text { text: "Account Type"; font.pixelSize: 14; color: "#64748b"; font.family: "Inter" }
                            Text { text: "Administrator"; font.pixelSize: 16; color: "#0f172a"; font.family: "Inter"; font.weight: Font.Medium }
                        }
                    }
                }
            }

            // =================================================================
            // 3. CHANGE PASSWORD CARD
            // =================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: changePwdCol.implicitHeight + 48
                radius: 12
                color: "white"
                border.color: "#e2e8f0"
                border.width: 1

                // Dim the entire card if not editing
                opacity: isEditing ? 1.0 : 0.6

                ColumnLayout {
                    id: changePwdCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 24
                    spacing: 24

                    Text {
                        text: "Change Password"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: "#0f172a"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        spacing: 20

                        // Field 1: Current Password
                        ColumnLayout {
                            spacing: 8
                            Layout.fillWidth: true
                            Text { text: "Current Password"; font.pixelSize: 14; color: "#0f172a"; font.weight: Font.Medium; font.family: "Inter" }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 44
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                TextInput {
                                    id: currentPwdInput
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 40
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    echoMode: showCurrentPwd ? TextInput.Normal : TextInput.Password
                                    enabled: isEditing
                                    Text {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        text: "Enter current password"
                                        color: "#94a3b8"
                                        font.pixelSize: 15
                                        font.family: "Inter"
                                        visible: parent.text === "" && !currentPwdInput.activeFocus
                                    }
                                }
                                Text {
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 16
                                    text: "👁"
                                    color: showCurrentPwd ? "#3b82f6" : "#94a3b8"
                                    font.pixelSize: 16
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -10
                                        cursorShape: isEditing ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: {
                                            if (isEditing) showCurrentPwd = !showCurrentPwd
                                        }
                                    }
                                }
                            }
                        }

                        // Field 2: New Password
                        ColumnLayout {
                            spacing: 8
                            Layout.fillWidth: true
                            Text { text: "New Password"; font.pixelSize: 14; color: "#0f172a"; font.weight: Font.Medium; font.family: "Inter" }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 44
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                TextInput {
                                    id: newPwdInput
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 40
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    echoMode: showNewPwd ? TextInput.Normal : TextInput.Password
                                    enabled: isEditing
                                    Text {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        text: "Enter new password"
                                        color: "#94a3b8"
                                        font.pixelSize: 15
                                        font.family: "Inter"
                                        visible: parent.text === "" && !newPwdInput.activeFocus
                                    }
                                }
                                Text {
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 16
                                    text: "👁"
                                    color: showNewPwd ? "#3b82f6" : "#94a3b8"
                                    font.pixelSize: 16
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -10
                                        cursorShape: isEditing ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: {
                                            if (isEditing) showNewPwd = !showNewPwd
                                        }
                                    }
                                }
                            }
                        }

                        // Field 3: Confirm Password
                        ColumnLayout {
                            spacing: 8
                            Layout.fillWidth: true
                            Text { text: "Confirm Password"; font.pixelSize: 14; color: "#0f172a"; font.weight: Font.Medium; font.family: "Inter" }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 44
                                radius: 8
                                color: "#f8fafc"
                                border.color: "#e2e8f0"
                                border.width: 1
                                TextInput {
                                    id: confirmPwdInput
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 40
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.pixelSize: 15
                                    font.family: "Inter"
                                    color: "#0f172a"
                                    echoMode: showConfirmPwd ? TextInput.Normal : TextInput.Password
                                    enabled: isEditing
                                    Text {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        text: "Confirm new password"
                                        color: "#94a3b8"
                                        font.pixelSize: 15
                                        font.family: "Inter"
                                        visible: parent.text === "" && !confirmPwdInput.activeFocus
                                    }
                                }
                                Text {
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 16
                                    text: "👁"
                                    color: showConfirmPwd ? "#3b82f6" : "#94a3b8"
                                    font.pixelSize: 16
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -10
                                        cursorShape: isEditing ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: {
                                            if (isEditing) showConfirmPwd = !showConfirmPwd
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Save Changes Button (Only visible when editing)
            Rectangle {
                width: 140
                height: 42
                radius: 6
                color: "#3b82f6" // Project's blue color
                visible: isEditing
                
                Text {
                    anchors.centerIn: parent
                    text: "Save Changes"
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: settingsController.saveChanges(currentFullName, currentEmail, currentContact)
                }
            }
            
            // Bottom Spacing Buffer
            Item {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 32
            }
        }
    }
}