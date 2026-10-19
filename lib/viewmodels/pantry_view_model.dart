import '../models/pantry_item.dart';
import '../models/shopping_item.dart';
import 'repository_view_model.dart';

enum PantryFilter { all, low, out }

class PantryViewModel extends RepositoryViewModel {
  PantryViewModel(super.repository);

  PantryFilter _filter = PantryFilter.all;

  PantryFilter get filter => _filter;

  void setFilter(PantryFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  int countFor(PantryFilter filter) => _apply(repository.pantry, filter).length;

  /// Out of stock first, then low, then the rest. Alphabetical inside each.
  List<PantryItem> get items {
    final list = _apply(repository.pantry, _filter).toList();
    list.sort((a, b) {
      final byStatus = b.status.index.compareTo(a.status.index);
      return byStatus != 0 ? byStatus : a.name.compareTo(b.name);
    });
    return list;
  }

  Iterable<PantryItem> _apply(List<PantryItem> all, PantryFilter filter) =>
      switch (filter) {
        PantryFilter.all => all,
        PantryFilter.low => all.where((p) => p.status == StockStatus.low),
        PantryFilter.out => all.where((p) => p.status == StockStatus.out),
      };

  void add(String name, int quantity, String unit) =>
      repository.addPantryItem(name, quantity, unit);

  void increment(PantryItem item) =>
      repository.setPantryQuantity(item.id, item.quantity + 1);

  void decrement(PantryItem item) =>
      repository.setPantryQuantity(item.id, item.quantity - 1);

  void remove(PantryItem item) => repository.removePantryItem(item.id);

  bool addToShopping(PantryItem item) =>
      repository.addShoppingItem(item.name, source: ShoppingSource.pantry);

  static String? validateName(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Name the item' : null;

  static String? validateQuantity(String? value) {
    final qty = int.tryParse(value?.trim() ?? '');
    return (qty == null || qty < 0) ? 'Whole number, 0 or more' : null;
  }
}
