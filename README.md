# 📊 Personal Finance Dashboard

Tổng quan về cấu trúc của cái file này, mng nhớ đọc kĩ để hiểu cấu trúc và cái workflow nha
một vài hướng dẫn thêm tui có ghi vào docs: https://docs.google.com/document/d/1gSN3vh6dryw86OCvHgywqSVO04O7QHV6IxaESyr7VgY/edit?tab=t.zhbbnu9d614n
---

* **Tầng GUI (Giao diện):** Chỉ lo việc hiển thị (Vẽ bảng, nút bấm, ô nhập dữ liệu). Không chứa thuật toán hay logic tính toán.
* **Tầng Frontend (Điều khiển):** Bộ não trung gian. Lắng nghe sự kiện từ GUI (người dùng bấm nút), kiểm tra tính hợp lệ của dữ liệu, và gọi Backend để xử lý.
* **Tầng Backend (Dữ liệu & File I/O):** Định nghĩa cấu trúc dữ liệu (`struct/class`) và chịu trách nhiệm lưu trữ, đọc/ghi dữ liệu ra file dữ liệu (CSV).

---

## 📁 Chi Tiết Cấu Trúc Thư Mục & Mục Đích File

```text
📁 src/
  ├── 📄 CMakeLists.txt              # File cấu hình biên dịch chính (Quản lý khai báo file)
  ├── 📄 main.cpp                    # Điểm khởi chạy ứng dụng, nạp MainWindow
  │
  ├── 📁 gui/                        # TẦNG GIAO DIỆN (Chỉ chứa Layout C++)
  │     ├── 📄 mainwindow.h/.cpp     # Khung xương chính: Chứa Sidebar điều hướng và bộ lật trang
  │     ├── 📁 overview/             # Trang 1: Overview
  │     ├── 📁 transactions/         # Trang 2: Lịch sử giao dịch
  │     ├── 📁 bills/                # Trang 3: Quản lý hóa đơn
  │     ├── 📁 categories/           # Trang 4: Quản lý danh mục
  │     ├── 📁 budgets/              # Trang 5: Tiết kiệm & Ngân sách
  │     └── 📁 reports/              # Trang 6: Báo cáo & Phân tích
  │
  ├── 📁 frontend/                   # TẦNG LOGIC ĐIỀU KHIỂN (Controllers)
  │     # Chứa các file xử lý logic tương ứng cho từng trang để bắt sự kiện (Signals & Slots)
  │     └── 📁 overview, transactions, bills, categories, budgets, reports/
  │
  └── 📁 backend/                    # TẦNG DỮ LIỆU THUẦN C++ (Không dính dáng tới đồ họa)
        ├── 📁 models/               # Định nghĩa một vài cái class chung cho cả nhóm (mng tùy chỉnh vẫn được)
        │     ├── 📄 transaction.h   # Cấu trúc một khoản thu nhập/chi tiêu
        │     ├── 📄 bill.h          # Cấu trúc dữ liệu một hóa đơn
        │     ├── 📄 category.h      # Cấu trúc dữ liệu một danh mục
        │     └── 📄 budget.h        # Cấu trúc dữ liệu hạn mức ngân sách
        │
        └── 📁 storage/              # Quản lý Đọc/Ghi dữ liệu
              └── 📄 database_manager.h/.cpp # Quản lý mảng dữ liệu động (RAM) và File I/O (CSV)
