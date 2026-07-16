cmake_minimum_required(VERSION 3.16)

project(src VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets)

set(PROJECT_SOURCES
        main.cpp

        gui/mainwindow.h
        gui/mainwindow.cpp

        frontend/overview/overview_controller.h
        frontend/overview/overview_controller.cpp

        frontend/bills/bills_controller.h
        frontend/bills/bills_controller.cpp

        frontend/budgets/budgets_controller.h
        frontend/budgets/budgets_controller.cpp

        frontend/categories/categories_controller.h
        frontend/categories/categories_controller.cpp

        frontend/reports/reports_controller.h
        frontend/reports/reports_controller.cpp

        frontend/transactions/transactions_controller.h
        frontend/transactions/transactions_controller.cpp

        gui/overview/overview_widget.h
        gui/overview/overview_widget.cpp

        gui/transactions/transactions_widget.h
        gui/transactions/transactions_widget.cpp

        gui/transactions/add_transaction_dialog.h
        gui/transactions/add_transaction_dialog.cpp

        gui/bills/bills_widget.h
        gui/bills/bills_widget.cpp

        gui/categories/categories_widget.h
        gui/categories/categories_widget.cpp

        gui/budgets/budgets_widget.h
        gui/budgets/budgets_widget.cpp

        gui/reports/reports_widget.h
        gui/reports/reports_widget.cpp

        backend/models/transaction.h
        backend/models/bill.h
        backend/models/category.h
        backend/models/budget.h

        backend/models/transaction.cpp
        backend/models/bill.cpp
        backend/models/category.cpp
        backend/models/budget.cpp

        backend/storage/database_manager.h
        backend/storage/database_manager_category.cpp
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(src
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
        frontend/overview/overview_controller.cpp frontend/overview/overview_controller.h
        backend/models/saving.h backend/models/saving.cpp
        build/Desktop_Qt_6_11_1_MinGW_64_bit_Debug/categories.csv
        backend/storage/database_manager_bill.cpp
        backend/storage/database_manager_budget.cpp
        backend/storage/database_manager_saving.cpp
        backend/storage/database_manager_transaction.cpp
        gui/categories/categories_widget.ui
        gui/mainwindow.ui
        gui/bills/bills_widget.ui
        gui/budgets/budgets_widget.ui
        gui/overview/overview_widget.ui
        gui/reports/reports_widget.ui
        gui/transactions/transactions_widget.ui

    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET src APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(src SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(src
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(src PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.src)
endif()
set_target_properties(src PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS src
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(src)
endif()
