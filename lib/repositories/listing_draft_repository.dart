import '../database/app_database.dart';
import '../models/listing_draft.dart';

abstract class ListingDraftRepository {
  /// ListingDraft เดิมไม่มี path รูป จึงรับ imagePath แยกเข้ามา
  Future<void> saveDraft(ListingDraft draft, String imagePath);

  /// เรียงจากร่างที่แก้ไขล่าสุดก่อน
  Future<List<ListingDraftRow>> getAllDrafts();

  Future<void> deleteDraft(int id);
}
