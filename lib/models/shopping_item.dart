enum ShoppingSource { manual, pantry, plan }

class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.name,
    this.source = ShoppingSource.manual,
    this.checked = false,
  });

  final String id;
  final String name;
  final ShoppingSource source;
  final bool checked;

  ShoppingItem copyWith({bool? checked}) {
    return ShoppingItem(
      id: id,
      name: name,
      source: source,
      checked: checked ?? this.checked,
    );
  }
}
