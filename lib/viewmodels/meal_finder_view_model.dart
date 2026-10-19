import '../models/recipe.dart';
import '../models/shopping_item.dart';
import 'repository_view_model.dart';

class RecipeMatch {
  const RecipeMatch(this.recipe, this.have, this.missing);

  final Recipe recipe;
  final List<String> have;
  final List<String> missing;

  bool get canMake => missing.isEmpty;
}

/// "What can I make?" Ranks recipes by how few ingredients are missing.
class MealFinderViewModel extends RepositoryViewModel {
  MealFinderViewModel(super.repository) {
    useMyPantry();
  }

  final Set<String> _selected = {};

  Set<String> get selected => Set.unmodifiable(_selected);

  /// Every ingredient the user could pick: pantry items first, then the rest
  /// of the recipe ingredients.
  List<String> get ingredientOptions {
    final pantry = repository.pantry.map((p) => p.name).toList()..sort();
    final others = repository.recipes
        .expand((r) => r.ingredients)
        .toSet()
        .difference(pantry.toSet())
        .toList()
      ..sort();
    return [...pantry, ...others];
  }

  bool isInPantry(String ingredient) => repository.hasInStock(ingredient);

  void toggle(String ingredient) {
    if (!_selected.remove(ingredient)) _selected.add(ingredient);
    notifyListeners();
  }

  void useMyPantry() {
    _selected
      ..clear()
      ..addAll(repository.pantry.where((p) => p.quantity > 0).map((p) => p.name));
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  List<RecipeMatch> get matches {
    final list = <RecipeMatch>[];
    for (final recipe in repository.recipes) {
      final have = recipe.ingredients.where(_selected.contains).toList();
      if (have.isEmpty) continue;
      final missing =
          recipe.ingredients.where((i) => !_selected.contains(i)).toList();
      list.add(RecipeMatch(recipe, have, missing));
    }
    list.sort((a, b) {
      final byMissing = a.missing.length.compareTo(b.missing.length);
      return byMissing != 0 ? byMissing : a.recipe.name.compareTo(b.recipe.name);
    });
    return list;
  }

  List<RecipeMatch> get readyToCook => matches.where((m) => m.canMake).toList();

  List<RecipeMatch> get almostThere =>
      matches.where((m) => !m.canMake && m.missing.length <= 2).toList();

  void open(Recipe recipe) => repository.markDiscovered(recipe.id);

  int addMissingToShopping(RecipeMatch match) => match.missing
      .where((i) => repository.addShoppingItem(i, source: ShoppingSource.plan))
      .length;
}
