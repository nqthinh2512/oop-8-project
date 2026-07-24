cmake_minimum_required(VERSION 3.16)

project(FinanceDashboard VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

# 1. Insert C++ backend and frontend here
qt_add_executable(appFinanceDashboard
    main.cpp
    
    # Backend Storage
    backend/storage/database_manager.h
    backend/storage/database_manager_bill.cpp
    backend/storage/database_manager_budget.cpp
    backend/storage/database_manager_category.cpp
    backend/storage/database_manager_saving.cpp
    backend/storage/database_manager_transaction.cpp

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

)

# 2. INSERT QML FILES HERE
qt_add_qml_module(appFinanceDashboard
    URI src
    VERSION 1.0
    QML_FILES
        qml/Main.qml

    	# Pages:
    	qml/pages/dummy_page.qml

    	# Components:
    	qml/components/dummy_component.qml
)

target_link_libraries(appFinanceDashboard PRIVATE Qt6::Quick)

install(TARGETS appFinanceDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
