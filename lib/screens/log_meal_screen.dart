import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import '../models/meal.dart';
import '../widgets/section_card.dart';

class LogMealScreen extends StatefulWidget {
  const LogMealScreen({
    super.key,
    required this.store,
    this.meal,
    this.initialType,
    this.day,
  });

  final MealStore store;
  final Meal? meal;
  final MealType? initialType;
  final DateTime? day;

  @override
  State<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends State<LogMealScreen> {
  late final _name = TextEditingController(text: widget.meal?.name);
  late final _cost = TextEditingController(text: _num(widget.meal?.cost));
  late final _calories = TextEditingController(
    text: widget.meal?.calories.toString(),
  );
  late final _protein = TextEditingController(text: _num(widget.meal?.protein));
  late final _carbs = TextEditingController(text: _num(widget.meal?.carbs));
  late final _fat = TextEditingController(text: _num(widget.meal?.fat));
  late MealType _type =
      widget.meal?.type ?? widget.initialType ?? MealType.lunch;
  late TimeOfDay _time = TimeOfDay.fromDateTime(
    widget.meal?.eatenAt ?? DateTime.now(),
  );

  bool get _editing => widget.meal != null;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && double.tryParse(_cost.text) != null;

  static String? _num(double? value) {
    if (value == null) return null;
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toString();
  }

  @override
  void dispose() {
    for (final c in [_name, _cost, _calories, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    final base = widget.meal?.eatenAt ?? widget.day ?? DateTime.now();
    final eatenAt = DateTime(
      base.year,
      base.month,
      base.day,
      _time.hour,
      _time.minute,
    );
    final cost = double.parse(_cost.text);
    final calories = int.tryParse(_calories.text) ?? 0;
    final protein = double.tryParse(_protein.text) ?? 0;
    final carbs = double.tryParse(_carbs.text) ?? 0;
    final fat = double.tryParse(_fat.text) ?? 0;
    if (_editing) {
      widget.store.updateMeal(
        widget.meal!.copyWith(
          name: _name.text.trim(),
          type: _type,
          eatenAt: eatenAt,
          cost: cost,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
        ),
      );
    } else {
      widget.store.addMeal(
        name: _name.text.trim(),
        type: _type,
        eatenAt: eatenAt,
        cost: cost,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
    }
    Navigator.pop(context, true);
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String hint, {
    bool decimal = true,
    bool watch = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: decimal),
          decoration: InputDecoration(hintText: hint),
          onChanged: watch ? (_) => setState(() {}) : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RoundIconButton(
                icon: Icons.arrow_back,
                tooltip: 'Back',
                size: 46,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 12),
            ScreenHeader(title: _editing ? 'Edit meal' : 'Log a meal'),
            const Label('Meal name'),
            const SizedBox(height: 8),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Chicken adobo + rice',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            const Label('Meal type'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in MealType.values)
                  ChoiceChip(
                    label: Text(type.label),
                    selected: _type == type,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Label('Time'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.schedule),
              label: Text(_time.format(context)),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: const Size.fromHeight(54),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _field('Cost (₱)', _cost, '95', watch: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: _field('Calories', _calories, '620', decimal: false),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _field('Protein g', _protein, '34')),
                const SizedBox(width: 10),
                Expanded(child: _field('Carbs g', _carbs, '68')),
                const SizedBox(width: 10),
                Expanded(child: _field('Fat g', _fat, '20')),
              ],
            ),
            const SizedBox(height: 30),
            PopButton(
              label: _editing ? 'Save changes' : 'Save meal',
              color: AppColors.blue,
              onPressed: _canSave ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
