import 'package:flutter/material.dart';

import '../data/meal_store.dart';
import '../models/meal.dart';
import '../widgets/section_card.dart';

class LogMealScreen extends StatefulWidget {
  const LogMealScreen({super.key, required this.store});

  final MealStore store;

  @override
  State<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends State<LogMealScreen> {
  final _name = TextEditingController();
  final _cost = TextEditingController();
  final _calories = TextEditingController();
  MealType _type = MealType.lunch;
  TimeOfDay _time = TimeOfDay.now();

  bool get _canSave =>
      _name.text.trim().isNotEmpty && double.tryParse(_cost.text) != null;

  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    _calories.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    final now = DateTime.now();
    widget.store.addMeal(
      name: _name.text.trim(),
      type: _type,
      eatenAt: DateTime(now.year, now.month, now.day, _time.hour, _time.minute),
      cost: double.parse(_cost.text),
      calories: int.tryParse(_calories.text) ?? 0,
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LOG A MEAL')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Label('Meal name'),
          const SizedBox(height: 6),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Chicken adobo + rice'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          const Label('Meal type'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in MealType.values)
                ChoiceChip(
                  label: Text(type.label),
                  selected: _type == type,
                  onSelected: (_) => setState(() => _type = type),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Label('Time'),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: _pickTime,
            icon: const Icon(Icons.schedule),
            label: Text('${_time.format(context)} · Today'),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label('Cost (₱)'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cost,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(hintText: '95'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label('Calories'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _calories,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '620'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PopButton(label: 'Save meal', onPressed: _canSave ? _save : null),
        ],
      ),
    );
  }
}
