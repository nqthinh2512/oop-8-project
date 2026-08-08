# 📊 FManagement - Personal Finance Dashboard

**FManagement** is a cross-platform desktop personal finance management application developed using **C++17** and **Qt 6 (QML)**. The application allows users to track income and expenses, manage recurring monthly bills, set budget targets, accumulate savings goals, and analyze financial reports with **Dark Mode** and **Light Mode** theme support.

The project is engineered adhering strictly to **Object-Oriented Programming (OOP)** principles and standard **Software Design Patterns**, ensuring clean code separation, high maintainability, and seamless scalability.

---

## 🏗️ Software Architecture (3-Tier Layered Architecture)

The system is structured into 3 distinct layers to enforce Separation of Concerns:

1. **UI Layer (Presentation - `src/qml/`):**
   * Built with Qt Quick / QML providing a modern, responsive user interface and a centralized theme system (`AppTheme.qml`).
   * Contains 8 main view pages: `OverviewPage`, `TransactionsPage`, `BillsPage`, `BudgetsPage`, `SavingsPage`, `CategoriesPage`, `ReportsPage`, `SettingsPage`.
   * **Principle:** The UI layer strictly handles visual rendering and user event capture without containing financial algorithms or calculations.

2. **Controller Layer (Presentation Logic - `src/frontend/`):**
   * C++ Controllers inheriting from `QObject` (`OverviewController`, `TransactionsController`, `BillsController`, `BudgetsController`, `SavingsController`, `CategoriesController`, `ReportsController`, `SettingsController`).
   * Acts as a Mediator using Qt Signals & Slots to validate QML user input and invoke backend operations.

3. **Data & Storage Layer (Backend - `src/backend/`):**
   * **Models:** Pure C++ domain models (`Transaction`, `Income`, `Expense`, `Bill`, `Budget`, `Saving`, `Category`).
   * **DAOs:** Data Access Objects managing local CSV file persistence (`TransactionDAO`, `BillDAO`, `BudgetDAO`, `SavingDAO`, `CategoryDAO`).
   * **DatabaseManager:** Centralized memory cache manager and data coordinator.

---

## 🧩 Design Patterns & Architectural Decisions

The backend architecture applies 5 core Software Design Patterns and OOP principles:

### 1. Singleton Pattern (`DatabaseManager`)
* **Rationale:** Since application data is stored in local CSV files, using a Singleton guarantees that exactly **one instance** of `DatabaseManager` exists throughout the application lifecycle. This prevents file access collisions (file locks) when multiple controllers access storage and ensures in-memory data remains in sync across all views.

### 2. Facade Pattern (`DatabaseManager`)
* **Rationale:** The system contains 5 distinct DAO classes. `DatabaseManager` acts as a **Facade**, providing unified access points (`db.transactionDAO()`, `db.billDAO()`, etc.). QML Controllers interact through a single entry point rather than instantiating 5 separate DAOs, drastically reducing code coupling (Low Coupling).

### 3. Data Access Object - DAO Pattern (`IBaseDAO<T>`)
* **Rationale:** Defines an abstract `IBaseDAO<T>` interface with pure virtual CRUD methods. File I/O persistence is completely encapsulated within concrete DAO classes. If the project upgrades from CSV files to a relational database (**SQLite / PostgreSQL**), only the DAO implementation classes need to be replaced, without modifying a single line of QML UI or Controller code.

### 4. Inheritance & Polymorphism (`Transaction` Base Class)
* **Rationale:** Abstract base class `Transaction` defines pure virtual method `getSignedAmount()`. Subclasses `Income` and `Expense` override this method to return signed monetary values ($+$ for Income, $-$ for Expense). Net balance calculations operate polymorphically on a `QVector<Transaction*>` collection, eliminating manual `if/else` type checking.

### 5. Factory Method Pattern (`TransactionFactory`)
* **Rationale:** Centralizes instantiation rules for `Income` and `Expense` objects within `TransactionFactory::createTransaction(...)`, keeping controller logic clean and decoupled from concrete constructors.

### 6. Business Logic Encapsulation & Data Integrity
* **Model-Level Business Logic:** Calculations for remaining balance (`getRemainingAmount()`), spending percentage (`getProgressPercent()`), risk evaluation (`BudgetStatus`: Safe, Warning, Danger, Over), and savings contributions (`contribute(amount)`) are encapsulated directly inside C++ models (`Budget`, `Saving`).
* **Referential Data Integrity:** `CategoryDAO::migrateAndRemoveCategory()` safe category deletion logic reassigns linked transactions or bills to a target category, preventing orphaned records.

---

## 📁 Directory Structure (`src/`)

```text
📁 oop-8-project/
  ├── 📁 UML_FINANCE_MANAGEMENT/     # Contains 10 detailed UML class diagrams
  │     ├── 📄 All.png               # High-level architecture overview
  │     ├── 📄 Database Manager.png  # Singleton & Facade Pattern diagram
  │     ├── 📄 Transaction.png       # Polymorphism, DAO & Factory Pattern diagram
  │     ├── 📄 Category.png          # Category management & migration diagram
  │     ├── 📄 Bill.png              # Bill management diagram
  │     ├── 📄 Budget.png            # Budget management & status diagram
  │     ├── 📄 Saving.png            # Savings goal management & contribution diagram
  │     └── 📄 Overview & Report.png # Controller summary aggregation diagram
  │
  └── 📁 src/                        # MAIN SOURCE CODE DIRECTORY
        ├── 📄 CMakeLists.txt         # Main CMake build specification
        ├── 📄 main.cpp               # C++ application entry point
        │
        ├── 📁 backend/               # C++ BACKEND DATA LAYER
        │     ├── 📁 models/          # Domain models (Income, Expense, Bill, Budget, Saving, Category)
        │     ├── 📁 dao/             # IBaseDAO interface and implementations (TransactionDAO, etc.)
        │     └── 📁 storage/         # DatabaseManager (Singleton & Facade)
        │
        ├── 📁 frontend/              # CONTROLLER LAYER
        │     ├── 📄 overview_controller.h/.cpp
        │     ├── 📄 transactions_controller.h/.cpp
        │     ├── 📄 bills_controller.h/.cpp
        │     ├── 📄 budgets_controller.h/.cpp
        │     ├── 📄 savings_controller.h/.cpp
        │     ├── 📄 categories_controller.h/.cpp
        │     ├── 📄 reports_controller.h/.cpp
        │     └── 📄 settings_controller.h/.cpp
        │
        ├── 📁 qml/                   # QML PRESENTATION LAYER
        │     ├── 📄 Main.qml         # Root window container with Sidebar & PageStack
        │     ├── 📄 core/            # System Theme (AppTheme.qml)
        │     ├── 📄 pages/           # 8 main application view pages
        │     ├── 📁 components/      # Reusable UI widgets, buttons, dropdowns, search bars
        │     └── 📁 assets/          # Icons, logos, and visual assets
        │
        └── 📁 data/                  # CSV STORAGE DIRECTORY
              ├── 📄 transactions.csv
              ├── 📄 bills.csv
              ├── 📄 budgets.csv
              ├── 📄 savings.csv
              └── 📄 categories.csv
```

---

## 🛠️ Build & Execution Instructions

### Prerequisites
* **Qt 6.x** (Qt 6.5+ recommended with **Qt Quick** and **Qt Quick Controls** modules).
* **CMake 3.16+**.
* C++ compiler with **C++17** support (MSVC 2019+, GCC 10+, or Clang 12+).

---

### Step 1: Clone the GitHub Repository
Clone the project repository to your local machine using Git:

```bash
# Clone the repository
git clone https://github.com/nqthinh2512/oop-8-project.git

# Navigate into the project directory
cd oop-8-project
```

---

### Step 2: Build & Run the Application

#### Option A: Using Qt Creator (Recommended)
1. Open **Qt Creator**.
2. Select `File` $\rightarrow$ `Open File or Project...` and open `src/CMakeLists.txt`.
3. Choose your configured Kit (e.g., `Desktop Qt 6.x.x MSVC2019 64bit` or `MinGW 64-bit`).
4. Click **Build & Run** (`Ctrl + R`).

#### Option B: Using Command Line (Terminal / PowerShell)
```bash
# 1. Navigate to the source directory
cd src

# 2. Create a build directory and configure CMake
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release

# 3. Compile the project
cmake --build .

# 4. Run the compiled executable
./appFinanceDashboard
```

---

*Developed for the Object-Oriented Programming (OOP 2) Course.*
