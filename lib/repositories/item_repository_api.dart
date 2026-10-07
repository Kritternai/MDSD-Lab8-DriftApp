import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import 'item_repository.dart';

class ItemRepositoryApi implements ItemRepository {
  // fakestoreapi.com ล่ม (ตอบ 521) มาตั้งแต่ 6 ต.ค. 2026 จึงใช้ DummyJSON แทน
  // ฟิลด์ id/title/price/description/category เหมือนกัน ต่างแค่ห่อ List ไว้ใน key 'products'
  static const _baseUrl = 'https://dummyjson.com/products?limit=20';

  @override
  Future<List<Item>> getItems() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = body['products'] as List<dynamic>;
        return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('ไม่สามารถโหลดรายการสินค้าได้ (สถานะ ${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
    } catch (e) {
      rethrow;
    }
  }
}
