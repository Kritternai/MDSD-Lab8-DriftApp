import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openConnection() {
  // LazyDatabase รอให้หา path ของโฟลเดอร์เอกสารในเครื่องเสร็จก่อนค่อยเปิดไฟล์
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'campus_marketplace.sqlite'));
    // createInBackground ย้ายงานฐานข้อมูลไปอีก isolate ไม่ให้ UI กระตุก
    return NativeDatabase.createInBackground(file);
  });
}
