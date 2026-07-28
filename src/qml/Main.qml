import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import "components/sidebar"
import "components/dialogs"
import "pages"


Window {
    id: mainWindow
    width: 1920
    height: 1080
    visible: true
    title: "Finance Dashboard App"

    visibility: Window.Maximized

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 1. SIDEBAR NAVIGATION MENU
        Sidebar_menu_1 {
            id: sidebarMenu
            Layout.fillHeight: true
            Layout.preferredWidth: 330
        }

        // 2. PAGE CONTAINER (Switches page based on sidebar selection)
        StackLayout {
            id: pageStack
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: sidebarMenu.selectedIndex

            // --- 8 MAIN PAGES ---
            OverviewPage { }      // Index 0
            TransactionsPage { }  // Index 1
            BillsPage { }         // Index 2
            BudgetsPage { }       // Index 3
            SavingsPage { }       // Index 4
            CategoriesPage { }    // Index 5
            ReportsPage { }       // Index 6
            SettingsPage { }      // Index 7
        }
    }

    DialogTestOverlay {} //Cái này chỉ để "preview" mấy cái dialog trông như thế nào thôi, nếu không cần nữa chỉ cần đóng comment nó lại.
}