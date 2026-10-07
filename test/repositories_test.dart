import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_marketplace_w7/database/app_database.dart';
import 'package:campus_marketplace_w7/models/listing_draft.dart';
import 'package:campus_marketplace_w7/repositories/favorites_repository_drift.dart';
import 'package:campus_marketplace_w7/repositories/listing_draft_repository_drift.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('FavoritesRepositoryDrift', () {
    test('กดหัวใจสินค้าเดิมซ้ำแล้วยังมีแค่แถวเดียว ไม่ error', () async {
      final repo = FavoritesRepositoryDrift(db);
      await repo.addFavorite(1, 'Mascara', 9.99, 'https://example.com/1.png');
      await repo.addFavorite(1, 'Mascara', 9.99, 'https://example.com/1.png');

      final favorites = await repo.getAllFavorites();
      expect(favorites.length, 1);
      expect(favorites.single.itemId, 1);
    });

    test('เรียงจากกดถูกใจล่าสุดก่อน และลบตาม itemId ได้', () async {
      final repo = FavoritesRepositoryDrift(db);
      // currentDateAndTime ของ SQLite ละเอียดระดับวินาที จึงใส่ addedAt เองให้ต่างกันชัดเจน
      for (final (id, minute) in [(1, 0), (2, 1), (3, 2)]) {
        await db.into(db.favoriteItems).insert(FavoriteItemsCompanion.insert(
              itemId: id,
              title: 'item $id',
              price: id.toDouble(),
              imageUrl: '',
              addedAt: drift.Value(DateTime(2026, 10, 7, 10, minute)),
            ));
      }
      expect((await repo.getAllFavorites()).map((f) => f.itemId), [3, 2, 1]);

      await repo.removeFavorite(2);
      expect((await repo.getAllFavorites()).map((f) => f.itemId), [3, 1]);
    });
  });

  group('ListingDraftRepositoryDrift', () {
    test('บันทึกร่างพร้อม path รูป อ่านกลับมาได้ และลบได้', () async {
      final repo = ListingDraftRepositoryDrift(db);
      const draft = ListingDraft(title: 'หูฟังไร้สาย', category: 'อุปกรณ์อิเล็กทรอนิกส์', description: 'สภาพดี');
      await repo.saveDraft(draft, '/tmp/headphones.jpg');

      final drafts = await repo.getAllDrafts();
      expect(drafts.single.title, 'หูฟังไร้สาย');
      expect(drafts.single.imagePath, '/tmp/headphones.jpg');

      await repo.deleteDraft(drafts.single.id);
      expect(await repo.getAllDrafts(), isEmpty);
    });
  });
}
