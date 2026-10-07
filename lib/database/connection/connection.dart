// แอปนี้รันทั้งบนมือถือ/desktop และ Flutter Web แต่การเปิดไฟล์ SQLite ต่างกัน
// จึงแยกเป็น 2 ไฟล์แล้วให้ Dart เลือกตอนคอมไพล์ (web ไม่มี dart:io ให้ใช้ File)
export 'native.dart' if (dart.library.js_interop) 'web.dart';
