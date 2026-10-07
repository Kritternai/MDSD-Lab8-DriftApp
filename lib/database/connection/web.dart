import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor openConnection() {
  // บน Web ใช้ SQLite ที่คอมไพล์เป็น WebAssembly (web/sqlite3.wasm) รันผ่าน worker (web/drift_worker.js)
  // ข้อมูลเก็บใน storage ของเบราว์เซอร์ (OPFS หรือ IndexedDB) ปิดแท็บแล้วเปิดใหม่ข้อมูลยังอยู่
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'campus_marketplace',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  }));
}
