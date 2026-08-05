cmake_minimum_required(VERSION 3.16)

# Sửa LANGUAGES CXX thành LANGUAGES C CXX để tương thích với Qt6 và Threads
project(FinanceDashboard VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Disable QML Ahead-Of-Time C++ code generation to prevent compiling 70+ QML files into 500MB of C++ .obj files
set(QT_NO_CREATE_QMLCACHE ON CACHE BOOL "Disable QML cache generation" FORCE)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

# 1. Insert C++ backend and frontend here
qt_add_executable(appFinanceDashboard
    main.cpp

    # Backend Storage & DAO
    backend/dao/ibase_dao.h
    backend/dao/category_dao.h
    backend/dao/category_dao.cpp
    backend/dao/transaction_dao.h
    backend/dao/transaction_dao.cpp
    backend/dao/bill_dao.h
    backend/dao/bill_dao.cpp
    backend/dao/budget_dao.h
    backend/dao/budget_dao.cpp
    backend/dao/saving_dao.h
    backend/dao/saving_dao.cpp

    backend/storage/database_manager.h
    backend/storage/database_manager.cpp

    # Backend Model
    backend/models/category.h
    backend/models/category.cpp

    backend/models/budget.h
    backend/models/budget.cpp

    backend/models/bill.h
    backend/models/bill.cpp

    backend/models/saving.h
    backend/models/saving.cpp

    backend/models/transaction.h
    backend/models/transaction.cpp

    backend/models/transaction_factory.h
    backend/models/transaction_factory.cpp

    # Frontend Controllers
    frontend/overview_controller.h
    frontend/overview_controller.cpp

    frontend/categories_controller.h
    frontend/categories_controller.cpp

    frontend/budgets_controller.h
    frontend/budgets_controller.cpp

    frontend/bills_controller.h
    frontend/bills_controller.cpp

    frontend/reports_controller.h
    frontend/reports_controller.cpp

    frontend/transactions_controller.h
    frontend/transactions_controller.cpp

    frontend/savings_controller.h
    frontend/savings_controller.cpp

    frontend/settings_controller.cpp
    frontend/settings_controller.h

    frontend/session_controller.h
    frontend/session_controller.cpp
)

# 2. REGISTER QML MODULE & ALL QML FILES AND ASSETS
qt_add_qml_module(appFinanceDashboard
    URI src
    VERSION 1.0
    NO_CACHEGEN
    QML_FILES
        qml/Main.qml

        # Pages:
        qml/pages/OverviewPage.qml
        qml/pages/TransactionsPage.qml
        qml/pages/BillsPage.qml
        qml/pages/BudgetsPage.qml
        qml/pages/SavingsPage.qml
        qml/pages/CategoriesPage.qml
        qml/pages/ReportsPage.qml
        qml/pages/SettingsPage.qml
        qml/pages/SettingsPage_1.qml
        qml/pages/LoginPage.qml

        # Sidebar Components:
        qml/components/sidebar/Sidebar_menu_1.qml
        qml/components/sidebar/Sidebar_item_1.qml
        qml/components/sidebar/Sidebar_menu_app_name_1.qml

        # Table Row Delegates:
        qml/components/rows/TransactionRow_1.qml
        qml/components/rows/BillRow_1.qml
        qml/components/rows/BudgetRow_1.qml
        qml/components/rows/SavingRow_1.qml
        qml/components/rows/CategoryRow_1.qml

        # Modal Dialogs:
        qml/components/dialogs/BillDialog.qml
        qml/components/dialogs/BudgetDialog.qml
        qml/components/dialogs/SavingDialog.qml
        qml/components/dialogs/CategoryDialog.qml
        qml/components/dialogs/TransactionDialog.qml
        qml/components/dialogs/DeleteDialog.qml
        qml/components/dialogs/DeleteCategoryDialog.qml
        qml/components/dialogs/DialogTestOverlay.qml

        # Reusable UI Widgets & Cards:
        qml/components/GaugeMeter.qml
        qml/components/PageBox_1.qml
        qml/components/OverviewKpiCard.qml
        qml/components/Overview_item_1.qml
        qml/components/Priority_1.qml
        qml/components/ProgressInfo_1.qml
        qml/components/ProgressBar_2.qml
        qml/components/DateCycle_1.qml
        qml/components/DateStatus_1.qml
        qml/components/ReportBox1_1.qml
        qml/components/ReportBox2_1.qml
        qml/components/UniversalButton_1.qml
        qml/components/SearchBar_1.qml
        qml/components/Dropdown_1.qml
        qml/components/Indicator_1.qml
        qml/components/View_all_1.qml
        qml/components/Edit_2.qml
        qml/components/Edit_1.qml
        qml/components/Trash_1.qml
        qml/components/Clock_1.qml
        qml/components/Check.qml
        qml/components/Activity_1.qml
        qml/components/Award.qml
        qml/components/Bell.qml
        qml/components/Bill_1.qml
        qml/components/Button_1.qml
        qml/components/Button_Group.qml
        qml/components/Calendar_1.qml
        qml/components/Calendar_Button.qml
        qml/components/Calendar_Month_Field.qml
        qml/components/Calendar_Select_Group.qml
        qml/components/Calendar_Year_Field.qml
        qml/components/Chevron_down.qml
        qml/components/Chevron_left.qml
        qml/components/Chevron_right_1.qml
        qml/components/Chevron_right_2.qml
        qml/components/CompareBar.qml
        qml/components/Date_Input_Field_1.qml
        qml/components/Default.qml
        qml/components/Dollar_sign_1.qml
        qml/components/DropdownDialogBox.qml
        qml/components/DropdownItem.qml
        qml/components/Ellipse_1.qml
        qml/components/Ellipse_2.qml
        qml/components/End.qml
        qml/components/End_1.qml
        qml/components/Eye.qml
        qml/components/Eye_off.qml
        qml/components/Filter.qml
        qml/components/Form_Log_In.qml
        qml/components/Frame_133540.qml
        qml/components/Frame_133543.qml
        qml/components/Frame_133550.qml
        qml/components/Goal_1.qml
        qml/components/Grid_2.qml
        qml/components/Home_1.qml
        qml/components/Icon_Button.qml
        qml/components/Input_Field.qml
        qml/components/Line_2.qml
        qml/components/Login_empty.qml
        qml/components/Login_error_pwd.qml
        qml/components/Login_hide_pwd.qml
        qml/components/Login_show_pwd.qml
        qml/components/Octicon_goal_16.qml
        qml/components/Settings_1.qml
        qml/components/Star.qml
        qml/components/Star_1.qml
        qml/components/Text_Link.qml
        qml/components/Transaction.qml
        qml/components/Trend_1.qml
        qml/components/Type_bill.qml
        qml/components/Warning.qml
        qml/components/X.qml

    RESOURCES
        qml/assets/bell.png qml/assets/bill.png qml/assets/check.png qml/assets/choice.png qml/assets/choice_1.png qml/assets/choice_2.png qml/assets/choice_3.png qml/assets/choice_4.png qml/assets/choice_5.png qml/assets/choice_6.png qml/assets/ellipse_1.png qml/assets/ellipse_10.png qml/assets/ellipse_11.png qml/assets/ellipse_12.png qml/assets/ellipse_13.png qml/assets/ellipse_14.png qml/assets/ellipse_15.png qml/assets/ellipse_16.png qml/assets/ellipse_17.png qml/assets/ellipse_18.png qml/assets/ellipse_19.png qml/assets/ellipse_20.png qml/assets/ellipse_21.png qml/assets/ellipse_22.png qml/assets/ellipse_23.png qml/assets/ellipse_24.png qml/assets/ellipse_25.png qml/assets/ellipse_26.png qml/assets/ellipse_27.png qml/assets/ellipse_28.png qml/assets/ellipse_29.png qml/assets/ellipse_3.png qml/assets/ellipse_30.png qml/assets/ellipse_31.png qml/assets/ellipse_32.png qml/assets/ellipse_33.png qml/assets/ellipse_34.png qml/assets/ellipse_35.png qml/assets/ellipse_36.png qml/assets/ellipse_37.png qml/assets/ellipse_38.png qml/assets/ellipse_39.png qml/assets/ellipse_4.png qml/assets/ellipse_40.png qml/assets/ellipse_41.png qml/assets/ellipse_42.png qml/assets/ellipse_43.png qml/assets/ellipse_5.png qml/assets/ellipse_7.png qml/assets/ellipse_9.png qml/assets/end.png qml/assets/end_1.png qml/assets/filter.png qml/assets/fManagement.png qml/assets/fManagement_2.png qml/assets/goal.png qml/assets/header.png qml/assets/header_1.png qml/assets/header_2.png qml/assets/header_3.png qml/assets/header_4.png qml/assets/item_Bills_State_default.png qml/assets/item_Bills_State_hover.png qml/assets/item_Bills_State_selected.png qml/assets/item_Budgets_State_default.png qml/assets/item_Budgets_State_hover.png qml/assets/item_Budgets_State_selected.png qml/assets/item_Categories_State_default.png qml/assets/item_Categories_State_hover.png qml/assets/item_Categories_State_selected.png qml/assets/item_Overview_State_default.png qml/assets/item_Overview_State_hover.png qml/assets/item_Overview_State_selected.png qml/assets/item_Reports_State_default.png qml/assets/item_Reports_State_hover.png qml/assets/item_Reports_State_selected.png qml/assets/item_Savings_State_default.png qml/assets/item_Savings_State_hover.png qml/assets/item_Savings_State_selected.png qml/assets/item_Settings_State_default.png qml/assets/item_Settings_State_hover.png qml/assets/item_Settings_State_selected.png qml/assets/item_Transactions_State_default.png qml/assets/item_Transactions_State_hover.png qml/assets/item_Transactions_State_selected.png qml/assets/line_1.png qml/assets/line_10.png qml/assets/line_11.png qml/assets/line_12.png qml/assets/line_13.png qml/assets/line_14.png qml/assets/line_15.png qml/assets/line_16.png qml/assets/line_17.png qml/assets/line_18.png qml/assets/line_19.png qml/assets/line_2.png qml/assets/line_3.png qml/assets/line_4.png qml/assets/line_5.png qml/assets/line_6.png qml/assets/line_7.png qml/assets/line_8.png qml/assets/line_9.png qml/assets/meter.png qml/assets/meter_1.png qml/assets/options.png qml/assets/options_1.png qml/assets/options_3.png qml/assets/options_4.png qml/assets/overview_item.png qml/assets/overview_item_1.png qml/assets/overview_item_2.png qml/assets/overview_item_3.png qml/assets/overview_item_4.png qml/assets/overview_item_5.png qml/assets/overview_item_6.png qml/assets/overview_item_7.png qml/assets/overview_item_8.png qml/assets/overview_item_9.png qml/assets/row.png qml/assets/row_1.png qml/assets/row_2.png qml/assets/row_3.png qml/assets/row_4.png qml/assets/row_5.png qml/assets/row_6.png qml/assets/row_7.png qml/assets/sidebar_item.png qml/assets/sidebar_item_1.png qml/assets/sidebar_item_12.png qml/assets/sidebar_item_13.png qml/assets/sidebar_item_2.png qml/assets/sidebar_item_3.png qml/assets/sidebar_item_4.png qml/assets/sidebar_item_5.png qml/assets/sidebar_item_6.png qml/assets/sidebar_item_7.png qml/assets/sidebar_item_9.png qml/assets/title.png qml/assets/title_1.png qml/assets/title_10.png qml/assets/title_11.png qml/assets/title_12.png qml/assets/title_13.png qml/assets/title_14.png qml/assets/title_15.png qml/assets/title_2.png qml/assets/title_3.png qml/assets/title_4.png qml/assets/title_5.png qml/assets/title_6.png qml/assets/title_7.png qml/assets/title_8.png qml/assets/title_9.png qml/assets/transaction.png qml/assets/trend.png qml/assets/type_bill.png qml/assets/type_bill_1.png qml/assets/type_expense.png qml/assets/type_income.png qml/assets/warning.png
        RESOURCES data/auth.csv data/bills.csv data/budgets.csv data/categories.csv data/savings.csv data/session.txt data/transactions.csv
    )

target_link_libraries(appFinanceDashboard PRIVATE Qt6::Quick)

install(TARGETS appFinanceDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)