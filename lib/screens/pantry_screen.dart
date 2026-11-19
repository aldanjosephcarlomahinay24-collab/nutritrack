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
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            ScreenHeader(eyebrow: '${items.length} items', title: 'Pantry'),
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
                const SizedBox(width: 12),
                RoundIconButton(
                  icon: Icons.add,
                  tooltip: 'Add',
                  onPressed: _add,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (items.isEmpty)
              const SectionCard(
                child: Text(
                  'Your pantry is empty.',
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            for (final item in items) ...[
              SectionCard(
                padding: const EdgeInsets.fromLTRB(20, 14, 10, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Pill(
                            'QTY ${item.quantity}',
                            color: AppColors.blueSoft,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: () => widget.store.removePantryItem(item.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}
