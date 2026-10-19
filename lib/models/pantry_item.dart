enum StockStatus { inStock, low, out }

/// Something the user has at home. [lowAt] is the quantity at or below which
/// the item counts as running low.
class PantryItem {
  const PantryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.lowAt = 1,
  });

  final String id;
  final String name;
  final int quantity;
  final String unit;
  final int lowAt;

  StockStatus get status {
    if (quantity <= 0) return StockStatus.out;
    if (quantity <= lowAt) return StockStatus.low;
    return StockStatus.inStock;
  }

  PantryItem copyWith({int? quantity}) {
    return PantryItem(
      id: id,
      name: name,
      quantity: quantity ?? this.quantity,
      unit: unit,
      lowAt: lowAt,
    );
  }
}
