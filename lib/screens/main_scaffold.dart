import 'package:flutter/material.dart';
import 'home_page.dart';
import 'sell_item_page.dart';
import 'favorites_page.dart';
import '../repositories/item_repository.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/listing_draft_repository.dart';

class MainScaffold extends StatefulWidget {
  final ItemRepository itemRepository;
  final FavoritesRepository favoritesRepository;
  final ListingDraftRepository draftRepository;
  const MainScaffold({
    super.key,
    required this.itemRepository,
    required this.favoritesRepository,
    required this.draftRepository,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // ใช้ key เรียก reload() ของหน้ารายการโปรดทุกครั้งที่สลับมา Tab นี้
  // เพราะ IndexedStack เก็บหน้าไว้ตลอด initState จึงไม่ถูกเรียกซ้ำ ถ้าไม่ reload จะไม่เห็นของที่เพิ่งกดถูกใจ
  final _favoritesKey = GlobalKey<FavoritesPageState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        repository: widget.itemRepository,
        favoritesRepository: widget.favoritesRepository,
      ),
      SellItemPage(draftRepository: widget.draftRepository),
      FavoritesPage(key: _favoritesKey, repository: widget.favoritesRepository),
    ];

    return Scaffold(
      // IndexedStack เก็บ State ของทุก Tab ไว้พร้อมกัน สลับ Tab แล้วข้อมูลที่กรอก/เลือกไว้ไม่หาย
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 2) _favoritesKey.currentState?.reload();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'ลงประกาศขาย'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'รายการโปรด'),
        ],
      ),
    );
  }
}
