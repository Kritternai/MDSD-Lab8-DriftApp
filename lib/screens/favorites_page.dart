import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../repositories/favorites_repository.dart';

class FavoritesPage extends StatefulWidget {
  final FavoritesRepository repository;
  const FavoritesPage({super.key, required this.repository});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  late Future<List<FavoriteItem>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = widget.repository.getAllFavorites();
  }

  /// โหลดรายการใหม่จากฐานข้อมูล (เรียกตอนสลับมา Tab นี้ และหลังลบรายการ)
  void reload() {
    setState(() => _favoritesFuture = widget.repository.getAllFavorites());
  }

  Future<void> _remove(FavoriteItem favorite) async {
    try {
      await widget.repository.removeFavorite(favorite.itemId);
      reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('ลบ "${favorite.title}" ออกจากรายการโปรดแล้ว')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('ลบรายการไม่สำเร็จ กรุณาลองใหม่')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรด')),
      body: FutureBuilder<List<FavoriteItem>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('โหลดรายการโปรดไม่สำเร็จ: ${snapshot.error}'));
          }
          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'ยังไม่มีรายการโปรด ลองกดหัวใจที่หน้าหลักดูสิ',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return ListTile(
                // รูป ชื่อ ราคา มาจากสำเนาในฐานข้อมูลทั้งหมด ไม่ต้องเรียก API ซ้ำ จึงแสดงได้แม้ไม่มีเน็ต
                // (ตัวรูปเองยังต้องโหลดจาก URL ถ้าไม่มีเน็ตจะขึ้นไอคอนแทน)
                leading: Image.network(
                  favorite.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                ),
                title: Text(favorite.title),
                subtitle: Text('${favorite.price} บาท'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'ลบออกจากรายการโปรด',
                  onPressed: () => _remove(favorite),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
