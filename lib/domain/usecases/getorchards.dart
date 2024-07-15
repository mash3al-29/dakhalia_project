import 'package:dakhalia_project/data/models/orchard_model.dart';
import 'package:dakhalia_project/domain/repoistories/orchard_repositiory.dart';

class GetOrchards {
  final OrchardRepository repository;

  GetOrchards(this.repository);

  Future<List<OrchardModel>> call(int userId) {
    return repository.getOrchards(userId);
  }
}
