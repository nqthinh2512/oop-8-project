import QtQuick
import QtQuick.Layouts

Rectangle {
    id: loginPage
    color: "#f0f5ff"

    property string username: ""
    property string password: ""
    property bool rememberMe: false
    property bool showPassword: false
    property string errorMessage: ""

    function attemptLogin() {
        if (username.trim() === "" || password.trim() === "") {
            errorMessage = "Please enter both username and password."
            return
        }

        var success = sessionController.login(username.trim(), password, rememberMe)
        if (!success) {
            errorMessage = "Incorrect username or password. Please try again."
            password = ""
            passwordInput.text = ""
        } else {
            errorMessage = ""
        }
    }

    // Background flourish
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#eef2ff" }
            GradientStop { position: 1.0; color: "#f8fafc" }
        }
    }

    Rectangle {
        id: loginCard
        anchors.centerIn: parent
        width: 420
        height: cardColumn.implicitHeight + 64
        radius: 16
        color: "#ffffff"
        border.color: "#e2e8f0"
        border.width: 1

        ColumnLayout {
            id: cardColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 32
            spacing: 20

            // Logo
            Image {
                Layout.alignment: Qt.AlignHCenter
                source: Qt.resolvedUrl("../assets/fManagement.png")
                fillMode: Image.PreserveAspectFit
                Layout.preferredHeight: 48
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Welcome Back"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "#0f172a"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Sign in to FManagement to continue"
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#64748b"
                }
            }

            // Username Field
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "Username or Email"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#334155"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 46
                    radius: 8
                    color: "#f8fafc"
                    border.color: usernameInput.activeFocus ? "#3b82f6" : "#e2e8f0"
                    border.width: 1

                    TextInput {
                        id: usernameInput
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        verticalAlignment: TextInput.AlignVCenter
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: "#0f172a"
                        selectByMouse: true
                        text: loginPage.username
                        onTextChanged: loginPage.username = text
                        Keys.onReturnPressed: passwordInput.forceActiveFocus()

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: "e.g. admin"
                            color: "#94a3b8"
                            font: parent.font
                            visible: parent.text === "" && !parent.activeFocus
                        }
                    }
                }
            }

            // Password Field
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "Password"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#334155"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 46
                    radius: 8
                    color: "#f8fafc"
                    border.color: passwordInput.activeFocus ? "#3b82f6" : "#e2e8f0"
                    border.width: 1

                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 44
                        verticalAlignment: TextInput.AlignVCenter
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: "#0f172a"
                        selectByMouse: true
                        echoMode: loginPage.showPassword ? TextInput.Normal : TextInput.Password
                        text: loginPage.password
                        onTextChanged: loginPage.password = text
                        Keys.onReturnPressed: loginPage.attemptLogin()

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: "Enter your password"
                            color: "#94a3b8"
                            font: parent.font
                            visible: parent.text === "" && !parent.activeFocus
                        }
                    }

                    Item {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 8
                        width: 24
                        height: 24

                        Eye {
                            anchors.fill: parent
                            _size: Eye.Size.Size_24
                            visible: loginPage.showPassword
                        }
                        Eye_off {
                            anchors.fill: parent
                            _size: Eye_off.Size.Size_24
                            visible: !loginPage.showPassword
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            cursorShape: Qt.PointingHandCursor
                            onClicked: loginPage.showPassword = !loginPage.showPassword
                        }
                    }
                }
            }

            // Remember Me
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 18
                    height: 18
                    radius: 4
                    color: loginPage.rememberMe ? "#3b82f6" : "#f8fafc"
                    border.color: loginPage.rememberMe ? "#3b82f6" : "#cbd5e1"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "✓"
                        color: "white"
                        font.pixelSize: 12
                        visible: loginPage.rememberMe
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: loginPage.rememberMe = !loginPage.rememberMe
                    }
                }

                Text {
                    text: "Remember me on this device"
                    font.family: "Inter"
                    font.pixelSize: 13
                    color: "#334155"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: loginPage.rememberMe = !loginPage.rememberMe
                    }
                }
            }

            // Error Message
            Text {
                Layout.fillWidth: true
                text: loginPage.errorMessage
                color: "#dc2626"
                font.family: "Inter"
                font.pixelSize: 13
                wrapMode: Text.Wrap
                visible: loginPage.errorMessage !== ""
            }

            // Login Button
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 4
                height: 46
                radius: 8
                color: loginButtonArea.pressed ? "#2563eb" : "#3b82f6"

                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: loginButtonArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: loginPage.attemptLogin()
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 4
                text: "Demo account: admin / admin123"
                font.family: "Inter"
                font.pixelSize: 12
                color: "#94a3b8"
            }
        }
    }
}
