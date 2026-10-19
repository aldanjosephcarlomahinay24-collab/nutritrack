import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../models/food_log_entry.dart';
import '../../models/meal_type.dart';
import '../../viewmodels/food_log_view_model.dart';

/// Opens the log-a-meal sheet. Pass [existing] to edit an entry, or the preset
/// values to log a planned or suggested meal in one tap.
Future<void> showLogMealSheet(
  BuildContext context, {
  FoodLogEntry? existing,
  String? presetName,
  MealType? presetType,
  int? presetCalories,
  int? presetProtein,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _LogMealSheet(
      viewModel: context.read<FoodLogViewModel>(),
      existing: existing,
      presetName: presetName,
      presetType: presetType,
      presetCalories: presetCalories,
      presetProtein: presetProtein,
    ),
  );
}

class _LogMealSheet extends StatefulWidget {
  const _LogMealSheet({
    required this.viewModel,
    this.existing,
    this.presetName,
    this.presetType,
    this.presetCalories,
    this.presetProtein,
  });

  final FoodLogViewModel viewModel;
  final FoodLogEntry? existing;
  final String? presetName;
  final MealType? presetType;
  final int? presetCalories;
  final int? presetProtein;

  @override
  State<_LogMealSheet> createState() => _LogMealSheetState();
}

class _LogMealSheetState extends State<_LogMealSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _cost;
  late final TextEditingController _calories;
  late final TextEditingController _protein;
  late DateTime _time;
  late MealType _type;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _time = e?.time ?? widget.viewModel.defaultTime();
    _type = e?.mealType ?? widget.presetType ?? widget.viewModel.suggestedTypeFor(_time);
    _name = TextEditingController(text: e?.name ?? widget.presetName ?? '');
    _cost = TextEditingController(text: e == null ? '' : _plain(e.cost));
    _calories = TextEditingController(
        text: _optional(e?.calories ?? widget.presetCalories));
    _protein = TextEditingController(
        text: _optional(e?.protein ?? widget.presetProtein));
  }

  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    _calories.dispose();
    _protein.dispose();
    super.dispose();
  }

  String _plain(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  String _optional(int? v) => (v == null || v == 0) ? '' : '$v';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (picked == null) return;
    setState(() {
      _time = DateTime(_time.year, _time.month, _time.day, picked.hour, picked.minute);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final cost = double.tryParse(_cost.text.trim()) ?? 0;
    final calories = int.tryParse(_calories.text.trim()) ?? 0;
    final protein = int.tryParse(_protein.text.trim()) ?? 0;
    final vm = widget.viewModel;
    if (_isEdit) {
      vm.update(widget.existing!.copyWith(
        name: _name.text.trim(),
        mealType: _type,
        time: _time,
        cost: cost,
        calories: calories,
        protein: protein,
      ));
    } else {
      vm.add(
        name: _name.text,
        mealType: _type,
        time: _time,
        cost: cost,
        calories: calories,
        protein: protein,
      );
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isEdit ? 'Meal updated' : 'Meal logged  +10 XP'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_isEdit ? 'Edit meal' : 'Log a meal',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                autofocus: !_isEdit && widget.presetName == null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'What did you eat?',
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: FoodLogViewModel.validateName,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cost,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        prefixText: '₱ ',
                      ),
                      validator: FoodLogViewModel.validateCost,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56)),
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule),
                      label: Text(clockTime(_time)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  for (final type in MealType.values)
                    ChoiceChip(
                      avatar: Icon(type.icon, size: 18),
                      label: Text(type.label),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _calories,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Calories (optional)',
                        suffixText: 'kcal',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _protein,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein (optional)',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: _save,
                child: Text(_isEdit ? 'Save changes' : 'Log meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
