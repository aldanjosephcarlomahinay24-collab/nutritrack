import 'package:flutter/material.dart';

import 'app.dart';
import 'data/nutri_repository.dart';

void main() {
  runApp(NutriTrackApp(repository: NutriRepository.withSampleData()));
}
