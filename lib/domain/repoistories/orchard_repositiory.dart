import 'package:dakhalia_project/data/models/orchard_model.dart';

abstract class OrchardRepository {
  Future<List<OrchardModel>> getOrchards(int userId);
}
