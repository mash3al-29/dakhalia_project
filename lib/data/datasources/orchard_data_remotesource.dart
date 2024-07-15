import 'package:postgres/postgres.dart';
import '../models/orchard_model.dart';

class OrchardRemoteDataSource{
  Future<List<OrchardModel>> fetchOrchards(int userId) async {
    final connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'mytestdb',
        username: 'postgres',
        password: 'Asdasd12\$12',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    final result = await connection.execute('SELECT * FROM orchards where u_id = $userId');

    return result.map((row) {
      return OrchardModel(
        id: row[0] as int,
        crop: row[1] as String,
        feddans: row[2] as int,
        mm: row[3] as int,
        pestState: row[4] as String,
      );
    }).toList();
  }
}
