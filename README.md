# eXtremeGostManager
Gost Tunnel manager

<img width="922" height="725" alt="image" src="https://github.com/user-attachments/assets/f155f2f5-f691-477b-a677-68591ea20758" />


اسکریپت مدیریت حرفه‌ای تونل GOST برای سناریوی ایران ↔ خارج
طراحی شده برای پیاده‌سازی امن، ماژولار و قابل مدیریت تونل TCP بین دو سرور.

----

### معرفی پروژه eXtreme Gost Manager


یک اسکریپت Bash مبتنی بر منوی تعاملی است که امکان راه‌اندازی، مدیریت و مانیتورینگ تونل GOST را بین:

- سرور ایران (Forward / Entry Node)
- سرور خارج (Main VPN / Relay Node)
فراهم می‌کند.

این ابزار برای سناریوهایی طراحی شده که:
 
- سرور اصلی VPN در خارج قرار دارد
- کاربران داخل ایران به یک نقطه ورودی داخلی متصل می‌شوند

ارتباط بین ایران و خارج از طریق تونل رمزگذاری‌شده GOST برقرار می‌شود
----

### معماری شبکه

```
[ Client Inside Iran ]
           |
           v
    +------------------+
    |   IRAN SERVER    |
    |  (Forward Node)  |
    +------------------+
           |
   Encrypted GOST Tunnel
           |
           v
    +------------------+
    | FOREIGN SERVER   |
    |  (VPN + Relay)   |
    +------------------+
           |
           v
        Internet
```
### نقش‌ها
### سرور ایران

- اجرای GOST در حالت Forward
- فوروارد پورت‌های مشخص شده
- نقطه ورود کاربران داخلی
- فاقد سرویس VPN اصلی

### سرور خارج

- اجرای GOST در حالت Bind / Reverse
- میزبانی سرویس VPN اصلی (Xray, OpenVPN و غیره)
- دریافت اتصال از سرور ایران


-----------
### نصب

```
curl -O https://raw.githubusercontent.com/ExtremeDot/eXtremeGostManager/master/ex_gost_manager.sh && chmod +x ex_gost_manager.sh
mv ex_gost_manager.sh /usr/local/bin/extGostManager && chmod +x /usr/local/bin/extGostManager
```
### اجرای منو 

```
extGostManager
```

### برای حذف اسکریپت 
```
rm /usr/local/bin/extGostManager
```
---
### مراحل راه‌اندازی

1- اجرا روی سرور خارج

2- انتخاب نقش Foreign

3- تعیین Tunnel Port

4- تعیین Forward Ports

5- فعال‌سازی احراز هویت (توصیه می‌شود)

سپس:

1- اجرا روی سرور ایران

2- انتخاب نقش Iran

3- وارد کردن IP سرور خارج

4- وارد کردن پورت تونل

5- تعیین پورت‌های فوروارد

----
### سناریوهای پیشنهادی استفاده

- عبور از محدودیت‌های مسیریابی داخلی
- کاهش Packet Loss در لینک‌های بین‌المللی
- مخفی‌سازی ترافیک VPN اصلی
- افزایش پایداری سرویس کاربران داخل کشور

