import 'package:flutter/foundation.dart';

import '../data/nutri_repository.dart';

/// Base for view models that read from [NutriRepository]. Rebuilds the view
/// whenever the repository changes.
abstract class RepositoryViewModel extends ChangeNotifier {
  RepositoryViewModel(this.repository) {
    repository.addListener(_onRepositoryChanged);
  }

  final NutriRepository repository;

  void _onRepositoryChanged() => notifyListeners();

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
