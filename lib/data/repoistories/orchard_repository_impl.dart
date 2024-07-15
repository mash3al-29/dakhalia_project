import 'package:dakhalia_project/data/datasources/orchard_data_remotesource.dart';
import 'package:dakhalia_project/data/models/orchard_model.dart';
import 'package:dakhalia_project/domain/repoistories/orchard_repositiory.dart';

class OrchardRepositoryImpl implements OrchardRepository {
  final OrchardRemoteDataSource remoteDataSource;

  OrchardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrchardModel>> getOrchards(int userId) async {
    final orchardModels = await remoteDataSource.fetchOrchards(userId);
    return orchardModels.map((model) => OrchardModel(
      id: model.id,
      crop: model.crop,
      feddans: model.feddans,
      mm: model.mm,
      pestState: model.pestState,
    )).toList();
  }
}
