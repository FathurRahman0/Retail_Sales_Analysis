# Retail Sales Analysis

## 📌 Project Overview

Retail Sales Analysis adalah project Data Analyst yang bertujuan untuk menganalisis data transaksi retail, mulai dari proses data cleaning, exploratory data analysis (EDA), analisis menggunakan SQL, pembangunan data warehouse dengan Star Schema, hingga visualisasi menggunakan Power BI.

Project ini dibuat untuk menghasilkan insight yang dapat membantu memahami pola penjualan, kategori produk, metode pembayaran, lokasi transaksi, dan kontribusi pelanggan.

---

## 🎯 Objectives

Project ini memiliki beberapa tujuan utama:

- Membersihkan dan mempersiapkan data transaksi retail.
- Melakukan Exploratory Data Analysis (EDA).
- Menganalisis data menggunakan SQL Server.
- Membangun data warehouse dengan pendekatan Star Schema.
- Membuat dashboard interaktif menggunakan Power BI.
- Menghasilkan business insights dan rekomendasi berdasarkan data.

---

## 🗂️ Project Structure

Retail_Sales_Analysis/
│
├── data/
│   ├── raw/
│   │   └── retail_store_sales.csv
│   │
│   └── processed/
│       └── retail_store_sales_clean.csv
│
├── notebooks/
│   └── 01_Data_Analysis.ipynb
│
├── sql/
│   ├── 01_analysis.sql
│   └── 02_data_warehouse.sql
│
├── dashboard/
│   ├── Retail_Sales_Dashboard.pbix
│   └── dashboard_screenshot.png
│
├── reports/
│   └── business_insights.md
│
└── README.md

---

## 🛠️ Tools & Technologies

### Programming & Data Analysis

- Python 3.11
- Pandas
- Jupyter Notebook

### Database & SQL

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL

### Data Warehouse

- Star Schema
- Fact Table & Dimension Tables

### Data Visualization

- Microsoft Power BI
- DAX

### Development & Version Control

- Visual Studio Code
- Git
- GitHub

---

## 🔄 Project Workflow

Raw Dataset
↓
Data Cleaning
↓
Exploratory Data Analysis
↓
SQL Analysis
↓
Data Warehouse
↓
Power BI Dashboard
↓
Business Insights

---

## 🧹 Data Cleaning

Dataset awal memiliki:

- 12,575 rows
- 12 columns

Beberapa proses data cleaning yang dilakukan:

- Menangani missing value pada `Quantity`.
- Menangani missing value pada `Price Per Unit`.
- Mengisi nilai `Item` yang kosong dengan `Unknown`.
- Mengubah `Transaction Date` menjadi format tanggal.
- Menghapus data yang tidak memiliki `Quantity` dan `Total Spent` setelah proses cleaning.

Dataset hasil cleaning memiliki:

**11,971 transactions**

Kolom `Discount Applied` yang memiliki nilai kosong tidak langsung diubah menjadi `False` karena tidak terdapat bukti bahwa nilai kosong tersebut berarti tidak mendapatkan diskon.

---

## 📊 Exploratory Data Analysis

Beberapa analisis yang dilakukan:

- Distribusi Quantity.
- Distribusi Price Per Unit.
- Distribusi Total Spent.
- Sales berdasarkan kategori.
- Sales berdasarkan metode pembayaran.
- Sales berdasarkan lokasi.
- Sales berdasarkan tahun.
- Sales berdasarkan bulan.
- Top customers berdasarkan jumlah transaksi.
- Top customers berdasarkan total spending.

---

## 🗄️ Data Warehouse

Project menggunakan pendekatan **Star Schema** untuk mengorganisasi data analitik.

Struktur Star Schema:

DimCustomer
│
│
DimDate ──────── FactSales ──────── DimProduct
│
│
DimPayment

### Fact Table

#### FactSales

Berisi data transaksi dan measure utama seperti:

- TransactionID
- Quantity
- PricePerUnit
- TotalSpent
- CustomerKey
- ProductKey
- PaymentKey
- DateKey

### Dimension Tables

#### DimCustomer

Menyimpan informasi customer.

#### DimDate

Menyimpan informasi tanggal untuk kebutuhan analisis waktu.

#### DimProduct

Menyimpan informasi produk dan kategori.

#### DimPayment

Menyimpan informasi metode pembayaran dan lokasi transaksi.

---

## 📈 Power BI Dashboard

Dashboard dibuat menggunakan Power BI untuk memberikan gambaran performa penjualan secara interaktif.

Dashboard terdiri dari:

- Total Sales
- Total Transactions
- Average Transaction Value
- Distinct Customers
- Sales by Category
- Sales by Payment Method
- Sales by Location
- Monthly Sales Trend
- Top 10 Customers
- Year Filter

### Dashboard Preview

![Retail Sales Dashboard](dashboard/dashboard_screenshot.png)

---

## 💡 Key Business Insights

### 1. Butchers memiliki penjualan tertinggi

Kategori **Butchers** menghasilkan total sales sebesar **208,118**, menjadi kategori dengan penjualan tertinggi.

### 2. Milk Products memiliki penjualan terendah

Kategori **Milk Products** menghasilkan total sales sebesar **180,112**, menjadi kategori dengan penjualan terendah.

### 3. Online sedikit lebih tinggi dibandingkan In-store

Penjualan **Online** mencapai **791,401**, sedangkan **In-store** mencapai **760,670**.

### 4. Cash menjadi metode pembayaran dengan sales tertinggi

**Cash** menghasilkan sales sebesar **537,710**, lebih tinggi dibandingkan Digital Wallet dan Credit Card.

### 5. Tahun 2024 memiliki sales tertinggi

Total sales tahun **2024** mencapai **524,881**, menjadi yang tertinggi dalam periode data penuh.

> **Catatan:** Data tahun 2025 hanya tersedia sampai 18 Januari 2025 sehingga tidak dapat dibandingkan langsung dengan satu tahun penuh.

### 6. Average Transaction relatif stabil

Average Transaction berada di sekitar **129–130** pada tahun 2022–2024.

Hal ini menunjukkan bahwa perubahan total sales lebih berkaitan dengan aktivitas transaksi daripada perubahan besar pada nilai rata-rata transaksi.

---

## 📌 Business Recommendations

Berdasarkan hasil analisis:

1. Mempertahankan ketersediaan produk pada kategori dengan penjualan tinggi seperti Butchers.
2. Mengevaluasi kategori dengan penjualan lebih rendah seperti Milk Products.
3. Mengembangkan channel Online karena memberikan kontribusi sales sedikit lebih tinggi dibandingkan In-store.
4. Mempertahankan berbagai metode pembayaran untuk memberikan fleksibilitas kepada pelanggan.
5. Mengembangkan strategi customer retention untuk customer dengan kontribusi spending yang tinggi.

---

## 📊 Key Metrics

| Metric | Value |
|---|---:|
| Total Transactions | 11,971 |
| Total Sales | 1,552,071 |
| Average Transaction | 129.65 |
| Customers | 25 |
| Data Period | 2022–2025* |

*Data tahun 2025 hanya tersedia sampai 18 Januari 2025.*

---

## 👤 Author

**Fathur Rahman**

Data Analyst Portfolio Project