#include "transaction_dialog.h"
#include "ui_transaction_dialog.h"
#include "../../backend/storage/database_manager.h"
#include <QDateTime>

TransactionDialog::TransactionDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::TransactionDialog)
{
    ui->setupUi(this);

    // Xóa thanh tiêu đề màu đen (Frameless) và làm trong suốt nền cửa sổ thật để thấy góc bo tròn của Frame
    setWindowFlags(Qt::Dialog | Qt::FramelessWindowHint);
    setAttribute(Qt::WA_TranslucentBackground);

    // Mặc định ngày hôm nay
    ui->dateEdit->setDate(QDate::currentDate());

    // Tải danh mục vào ComboBox
    populateCategories();

    // Kết nối sự kiện thay đổi text để format số tiền
    connect(ui->editAmount, &QLineEdit::textEdited, this, &TransactionDialog::onAmountTextChanged);
}

TransactionDialog::~TransactionDialog()
{
    delete ui;
}

void TransactionDialog::onAmountTextChanged(const QString &text)
{
    // Bỏ qua nếu text trống
    if (text.isEmpty()) return;

    // Loại bỏ tất cả ký tự không phải số
    QString cleanText = text;
    cleanText.remove(QRegularExpression("[^0-9]"));

    // Thêm dấu chấm phân cách hàng nghìn
    QString formattedText = "";
    int count = 0;
    for (int i = cleanText.length() - 1; i >= 0; --i) {
        if (count > 0 && count % 3 == 0) {
            formattedText.prepend(".");
        }
        formattedText.prepend(cleanText[i]);
        count++;
    }

    // Đặt lại text nhưng không kích hoạt lại signal textEdited
    ui->editAmount->blockSignals(true);
    ui->editAmount->setText(formattedText);
    ui->editAmount->blockSignals(false);
}

void TransactionDialog::populateCategories()
{
    const QVector<Category>& categories = DatabaseManager::instance().getAllCategories();
    for (const Category& cat : categories) {
        // Lưu Id vào UserData (ẩn) và hiển thị Name
        ui->comboCategory->addItem(cat.getName(), cat.getId());
    }
}

QString TransactionDialog::getTransactionType() const
{
    if (ui->radIncome->isChecked()) {
        return "Thu";
    }
    return "Chi";
}

double TransactionDialog::getAmount() const
{
    QString text = ui->editAmount->text();
    text.remove("."); // Bỏ dấu chấm phân cách
    return text.toDouble();
}

int TransactionDialog::getCategoryId() const
{
    // Lấy Id đã được gài ngầm trong UserData của ComboBox
    return ui->comboCategory->currentData().toInt();
}

QString TransactionDialog::getPaymentMethod() const
{
    return ui->comboMethod->currentText();
}

QString TransactionDialog::getNote() const
{
    return ui->editNote->text();
}

QDateTime TransactionDialog::getDateTime() const
{
    // Lấy ngày từ dateEdit, giờ mặc định là 00:00 hoặc hiện tại
    QDate date = ui->dateEdit->date();
    return QDateTime(date, QTime::currentTime());
}
