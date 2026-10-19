import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../models/shopping_item.dart';
import '../../viewmodels/shopping_list_view_model.dart';
import '../../widgets/common.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _add(ShoppingListViewModel vm) {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    if (!vm.add(text)) {
      _toast('${capitalize(text.trim())} is already on the list');
    }
    _input.clear();
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShoppingListViewModel>();
    final items = vm.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            tooltip: 'Build from plan and pantry',
            onPressed: () {
              final added = vm.buildFromPlanAndPantry();
              _toast(added == 0
                  ? 'Nothing new. Your plan is covered.'
                  : 'Added $added item(s) from your plan and pantry');
            },
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      bottomNavigationBar: vm.checkedCount == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52)),
                  onPressed: () {
                    final moved = vm.clearChecked();
                    _toast('Moved $moved item(s) to your pantry');
                  },
                  icon: const Icon(Icons.done_all),
                  label: Text('Done shopping (${vm.checkedCount})'),
                ),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          TextField(
            controller: _input,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _add(vm),
            decoration: InputDecoration(
              hintText: 'Add an item',
              suffixIcon: IconButton(
                onPressed: () => _add(vm),
                icon: const Icon(Icons.add),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('${vm.remaining} to buy',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          if (items.isEmpty)
            EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'List is empty.',
              actionLabel: 'Build from my plan',
              onAction: vm.buildFromPlanAndPantry,
            )
          else
            Card(
              child: Column(
                children: [
                  for (final item in items)
                    CheckboxListTile(
                      value: item.checked,
                      onChanged: (_) => vm.toggle(item),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        capitalize(item.name),
                        style: item.checked
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough)
                            : null,
                      ),
                      subtitle: Text(_sourceLabel(item.source)),
                      secondary: IconButton(
                        tooltip: 'Remove',
                        onPressed: () => vm.remove(item),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _sourceLabel(ShoppingSource source) => switch (source) {
        ShoppingSource.manual => 'Added by you',
        ShoppingSource.pantry => 'Running low in pantry',
        ShoppingSource.plan => 'Needed for a planned meal',
      };
}
