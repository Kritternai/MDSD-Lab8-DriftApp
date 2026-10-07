import 'package:drift/drift.dart';
import 'connection/connection.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [FavoriteItems, ListingDrafts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // ใช้ในเทสต์ ส่งฐานข้อมูลในหน่วยความจำเข้ามาแทนไฟล์จริง
  AppDatabase.forTesting(super.executor);

  // ถ้าแก้โครงสร้างตารางหลังจากนี้ ต้องเพิ่มเลขนี้และเขียน migration รองรับ
  @override
  int get schemaVersion => 1;
}
