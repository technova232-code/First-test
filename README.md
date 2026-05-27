# Termux Hub

تطبيق Flutter باسم Termux Hub — مجموعة أدوات متخصصة لتيرمكس (عربي، RTL، وضع داكن).

ملفات مهمة:
- `lib/main.dart` — نقطة الدخول وضبط `MaterialApp` (Locale: ar, RTL، Material 3).
- `lib/screens/home_screen.dart` — الشاشة الرئيسية وقوائم الأدوات.
- `lib/data/tools_data.dart` — بيانات الـ 60 أداة.
- `lib/models/tool.dart` — موديل `Tool`.
- `lib/widgets/tool_tile.dart` — عنصر عرض الأداة.
- `pubspec.yaml` — تعريف الاعتمادات وassets.
- `assets/icon.png` — أيقونة مبدئية (استبدلها بأيقونة مصممة).

التثبيت والتشغيل:

تأكد من تثبيت Flutter على جهازك، ثم:

```bash
flutter pub get
flutter run
```

إنشاء نسخة APK محلياً:

```bash
flutter build apk --release
```

دمج AdMob:
- ضع `bannerAdUnitId` و`interstitialAdUnitId` في `lib/screens/home_screen.dart` و/أو `lib/main.dart`.

ربط GitHub مع FlutLab (مختصر):
1. أنشئ مستودع GitHub وادفع الكود.
2. سجل دخولك في FlutLab، عند إنشاء مشروع اختر استيراد من GitHub.
3. اربط المستودع، واختر الفرع `main`، واضبط متغيرات بيئة (AdMob IDs) إن لزم.
4. اطلب بناء APK من واجهة FlutLab.

ملحوظة حول الأيقونة:
- استبدل `assets/icon.png` بأيقونة بصيغة PNG بأبعاد مناسبة (512x512 أو 1024x1024) قبل بناء ونشر التطبيق.

هل تريد أن أنشئ ملف GitHub Actions أو ملف إرشادات مفصّلة لربط FlutLab/GitHub؟