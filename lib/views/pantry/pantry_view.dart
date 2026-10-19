import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../models/pantry_item.dart';
import '../../viewmodels/pantry_view_model.dart';
import '../../widgets/common.dart';

class PantryView extends StatelessWidget {
  const PantryView({super.key});

  static const _filterLabels = {
    PantryFilter.all: 'All',
    PantryFilter.low: 'Running low',
    PantryFilter.out: 'Out',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PantryViewModel>();
    final items = vm.items;
    return Scaffold(
      appBar: AppBar(title: const Text('Pantry')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'pantry-fab',
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final f in PantryFilter.values)
                FilterChip(
                  label: Text('${_filterLabels[f]} (${vm.countFor(f)})'),
                  selected: vm.filter == f,
                  onSelected: (_) => vm.setFilter(f),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const EmptyState(
              icon: Icons.inventory_2_outlined,
              message: 'Nothing here. Add what you have at home.',
            )
          else
            for (final item in items) _PantryTile(item: item),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final vm = context.read<PantryViewModel>();
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final qty = TextEditingController(text: '1');
    final unit = TextEditingController(text: 'pcs');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to pantry'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Item'),
                validator: PantryViewModel.validateName,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: qty,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: PantryViewModel.validateQuantity,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: unit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (saved == true) {
      vm.add(name.text, int.parse(qty.text.trim()), unit.text);
    }
    name.dispose();
    qty.dispose();
    unit.dispose();
  }
}

class _PantryTile extends StatelessWidget {
  const _PantryTile({required this.item});

  final PantryItem item;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PantryViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (item.status) {
      StockStatus.inStock => ('In stock', scheme.primary),
      StockStatus.low => ('Low', scheme.tertiary),
      StockStatus.out => ('Out', scheme.error),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          title: Text(capitalize(item.name)),
          subtitle: Row(
            children: [
              Text('${item.quantity} ${item.unit}'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(label,
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Use one',
                onPressed: item.quantity > 0 ? () => vm.decrement(item) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                tooltip: 'Add one',
                onPressed: () => vm.increment(item),
                icon: const Icon(Icons.add_circle_outline),
              ),
              PopupMenuButton<String>(
                onSelected: (action) {
                  final messenger = ScaffoldMessenger.of(context);
                  if (action == 'shop') {
                    final added = vm.addToShopping(item);
                    messenger.showSnackBar(SnackBar(
                      content: Text(added
                          ? 'Added ${item.name} to shopping list'
                          : '${capitalize(item.name)} is already on the list'),
                    ));
                  } else {
                    vm.remove(item);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'shop', child: Text('Add to shopping list')),
                  PopupMenuItem(value: 'remove', child: Text('Remove from pantry')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
