import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: testOverlay
    anchors.fill: parent

    // Instantiate all 7 Dialogs
    BudgetDialog { id: budgetDialog }
    SavingDialog { id: savingDialog }
    BillDialog { id: billDialog }
    TransactionDialog { id: transactionDialog }
    CategoryDialog { id: categoryDialog }
    DeleteDialog { id: deleteDialog }
    DeleteCategoryDialog { id: deleteCategoryDialog }

    // Quick Test Toolbar (Positioned at bottom center for quick previewing)
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        spacing: 10
        z: 9999

        UniversalButton_1 {
            buttonText: "Budget"
            onClicked: budgetDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Saving"
            onClicked: savingDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Bill"
            onClicked: billDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Transaction"
            onClicked: transactionDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Category"
            onClicked: categoryDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Delete"
            onClicked: deleteDialog.open()
        }
        UniversalButton_1 {
            buttonText: "Delete Cat"
            onClicked: deleteCategoryDialog.open()
        }
    }
}
