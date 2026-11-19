import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import '../widgets/section_card.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key, required this.store});

  final MealStore store;

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final _item = TextEditingController();

  @override
  void dispose() {
    _item.dispose();
    super.dispose();
  }

  void _add() {
    final name = _item.text.trim();
    if (name.isEmpty) return;
    widget.store.addPantryItem(name, 1);
    _item.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final items = widget.store.pantry;
        return Scaffold(
          appBar: AppBar(title: const Text('PANTRY')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _item,
                      decoration: const InputDecoration(
                        hintText: 'Add an ingredient',
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    child: PopButton(label: '+', onPressed: _add),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SectionCard(
                padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
                child: Column(
                  children: [
                    if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Your pantry is empty.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    for (final item in items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          'Qty ${item.quantity}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        trailing: IconButton(
                          tooltip: 'Remove',
                          onPressed: () =>
                              widget.store.removePantryItem(item.id),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
