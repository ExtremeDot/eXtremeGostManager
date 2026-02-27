# eXtremeGostManager — تغییرات نسخه‌ها

## [2.3.0] — 28 فوریه 2026
### 🆕 بروزرسانی نسخه
- بروزرسانی از **2.2.1** به **2.3.0**.

### ⚙️ تنظیمات پیش‌فرض
- اضافه شدن پارامترهای پیش‌فرض جدید برای تست سرعت:
  - `DEFAULT_IPERF_PORT`
  - `DEFAULT_IPERF_DURATION`
  - `DEFAULT_IPERF_PARALLEL`
  - `DEFAULT_IPERF_INTERVAL`
  - `DEFAULT_IPERF_PRESET`

### 🧪 بهبود تست سرعت (iperf3)
- تست کامل سرعت شبکه با طبقه‌بندی کیفیت (خیلی ضعیف / ضعیف / متوسط / …)
- نمایش سرعت‌های آپلود و دانلود در ترمینال
- تحلیل و امتیازدهی خودکار مقادیر ارسال و دریافت

### ⚡ رابط کاربری و منوی پیشرفته
- اضافه شدن **Transport Modes** پیشرفته: WSS-D، WSS-R، QUIC-R، gRPC-R، MTCP، OBFS و غیره
- منوی **Tunnel Check & Speed Test**
- مدیریت سرویس‌ها: شروع / توقف / ریستارت / وضعیت / لاگ‌ها / ویرایش

### 📡 قابلیت‌های تشخیص و عیب‌یابی تونل‌ها
- تابع جدید `check_tunnel_ip()` برای اعتبارسنجی تونل‌ها
- نمایش پیام خطا و راهنمایی برای رفع مشکلات

### 🔄 بروزرسانی خودکار
- اضافه شدن تابع `update_package()` برای بروزرسانی خودکار از گیت‌هاب

### 📝 تنظیمات قابل شخصی‌سازی تست سرعت
- انتخاب پیش‌فرض‌های سرعت بر اساس نوع شبکه
- تنظیم پورت، تعداد parallel streams و مدت زمان تست

### 🔍 تحلیل خروجی iperf3
- استخراج و تحلیل خروجی iperf3
- امتیازدهی کیفیت بر اساس نتایج تست

### 📁 ساختار کد و ظاهر
- لوگو با رنگ‌های بیشتر (افزوده شدن YELLOW)
- مقداردهی اولیه متغیرها در `load_config` گسترده‌تر شده است

---

### ⚡ خلاصه تغییرات مهم
- اضافه شدن **تست کامل سرعت شبکه** با iperf3  
- منوی پیشرفته با Transport Modes و قابلیت عیب‌یابی تونل‌ها  
- قابلیت بروزرسانی خودکار  
- پیش‌فرض‌ها و تنظیمات قابل شخصی‌سازی برای تست سرعت  
- خروجی تشخیصی بهتر و طبقه‌بندی کیفیت  
- بهبود تنظیمات پیش‌فرض و گزینه‌های بهینه‌سازی عملکرد
----------------

# eXtremeGostManager — Changelog

## [2.3.0] — 2026-02-28
### 🆕 Version Update
- Updated from **2.2.1** to **2.3.0**.

### ⚙️ Default Settings
- Added new default parameters for speed testing:
  - `DEFAULT_IPERF_PORT`
  - `DEFAULT_IPERF_DURATION`
  - `DEFAULT_IPERF_PARALLEL`
  - `DEFAULT_IPERF_INTERVAL`
  - `DEFAULT_IPERF_PRESET`

### 🧪 Speed Test (iperf3) Enhancements
- Full network speed testing with quality classification (Very Weak / Fair / Average / etc.)
- Upload/download speeds displayed in terminal.
- Receiver/sender metrics are analyzed and scored automatically.

### ⚡️ Advanced UI / Menu Options
- New **Transport Modes**: WSS-D, WSS-R, QUIC-R, gRPC-R, MTCP, OBFS, etc.
- Tunnel Check & Speed Test configuration menu.
- Service management options: Start / Stop / Restart / Status / Logs / Edit.

### 📡 Tunnel Diagnostic Features
- New function `check_tunnel_ip()` to validate tunnels.
- Error messages and troubleshooting guidance added.

### 🔄 Auto-Update
- `update_package()` function added for GitHub-based self-update.

### 📝 Configurable Speed Test
- Select default speed presets per network type.
- Configure port, parallel streams, and test duration.

### 🔍 iperf3 Output Parsing
- Outputs are parsed, extracted, and classified.
- Quality scoring implemented based on results.

### 📁 Code Structure & Appearance
- Logo updated with colors (YELLOW added).
- Expanded variable initialization in `load_config`.

---

### ⚡ Summary of Major Changes
- Integrated **extensive network speed testing** (iperf3).  
- Advanced UI with transport modes and tunnel diagnostics.  
- Auto-update function added.  
- Configurable speed test presets.  
- Improved diagnostic output and quality classification.  
- Broader defaults and performance tuning options.

