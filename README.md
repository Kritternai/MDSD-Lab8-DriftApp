# campus_marketplace_w7

MDSD Lab 8: Local Database & Persistence ด้วย Drift

แอป Campus Marketplace ต่อยอดจากใบงานสัปดาห์ที่ 5-7 สัปดาห์นี้เพิ่มฐานข้อมูล SQLite ในเครื่องด้วย Drift สำหรับฟีเจอร์ "รายการโปรด" (Tab ที่ 3) และบันทึกร่างประกาศขายที่ AI ช่วยร่างให้ถาวร ปิดแอปหรือไม่มีอินเทอร์เน็ตข้อมูลก็ยังอยู่

## โครงสร้างหลัก

- `lib/database/tables.dart` ตาราง `FavoriteItems` และ `ListingDrafts`
- `lib/database/app_database.dart` คลาสฐานข้อมูล (`app_database.g.dart` สร้างจาก `build_runner`)
- `lib/database/connection/` เปิดฐานข้อมูลแบบ native (มือถือ/desktop) หรือ WebAssembly (Flutter Web) ตามแพลตฟอร์ม
- `lib/repositories/favorites_repository*.dart`, `listing_draft_repository*.dart` Repository Pattern สำหรับฐานข้อมูลในเครื่อง
- `lib/screens/favorites_page.dart` Tab รายการโปรด
- `lib/screens/my_drafts_page.dart` หน้าร่างประกาศของฉัน (เปิดจาก AppBar ของหน้าลงประกาศขาย)
- `web/sqlite3.wasm`, `web/drift_worker.js` ไฟล์ที่ Drift ใช้บน Web (จาก release ทางการของ drift 2.35.1)

## การรัน

```bash
flutter pub get
dart run build_runner build
flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_API_KEY
flutter test
```

ห้าม commit API Key ให้ส่งผ่าน `--dart-define` เท่านั้น

หมายเหตุ: `fakestoreapi.com` ล่ม (ตอบ 521) หน้าหลักจึงดึงสินค้าจาก DummyJSON แทน

ใบงานและผลการทดลอง: https://github.com/Kritternai/MDSD-Lab8-Labsheet-2026
