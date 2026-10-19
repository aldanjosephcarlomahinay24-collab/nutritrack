import '../core/formatters.dart';
import '../models/pantry_item.dart';
import '../models/shopping_item.dart';
import 'repository_view_model.dart';

class ShoppingListViewModel extends RepositoryViewModel {
  ShoppingListViewModel(super.repository);

  /// Unchecked first, then checked, each in the order added.
  List<ShoppingItem> get items {
    final list = repository.shopping;
    return [
      ...list.where((s) => !s.checked),
      ...list.where((s) => s.checked),
    ];
  }

  int get remaining => repository.shopping.where((s) => !s.checked).length;
  int get checkedCount => repository.shopping.where((s) => s.checked).length;

  bool add(String name) => repository.addShoppingItem(name);
  void toggle(ShoppingItem item) => repository.toggleShoppingItem(item.id);
  void remove(ShoppingItem item) => repository.removeShoppingItem(item.id);
  int clearChecked() => repository.clearCheckedShopping();

  /// Grocery list = ingredients for planned meals from today on, minus what is
  /// already in the pantry, plus pantry items that ran low or out.
  int buildFromPlanAndPantry() {
    final today = dateOnly(repository.now());
    final needed = repository.plan
        .where((p) => !p.day.isBefore(today))
        .expand((p) => p.recipe.ingredients)
        .where((i) => !repository.hasInStock(i))
        .toSet();
    var added = 0;
    for (final name in needed) {
      if (repository.addShoppingItem(name, source: ShoppingSource.plan)) added++;
    }
    for (final item in repository.pantry) {
      if (item.status == StockStatus.inStock) continue;
      if (repository.addShoppingItem(item.name, source: ShoppingSource.pantry)) {
        added++;
      }
    }
    return added;
  }
}
