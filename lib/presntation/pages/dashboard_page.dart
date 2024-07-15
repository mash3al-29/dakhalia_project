import 'package:dakhalia_project/data/datasources/orchard_data_remotesource.dart';
import 'package:dakhalia_project/data/models/orchard_model.dart';
import 'package:dakhalia_project/data/repoistories/orchard_repository_impl.dart';
import 'package:dakhalia_project/presntation/pages/login_page.dart';
import 'package:dakhalia_project/presntation/widgets/custom_orchard_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  static const String routeId = "dashboard-page";

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userNickname;
  TextEditingController searchController = TextEditingController();
  late Future<List<OrchardModel>> _orchardsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _orchardsFuture = _fetchOrchards();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          _buildSideMenu(screenHeight, screenWidth),
          _buildOrchardsList(screenHeight, screenWidth),
        ],
      ),
    );
  }

  Widget _buildSideMenu(double screenHeight, double screenWidth) {
    return Container(
      width: screenWidth * 0.2,
      color:  Colors.white,
      child: ListView(
        children: [
          SizedBox(height: screenHeight * 0.15),
          Icon(
            Icons.person,
            size: screenHeight * 0.2,
          ),
          Center(
            child: Text(
              userNickname?.toUpperCase() ?? '',
              style: TextStyle(fontSize: screenWidth * 0.025),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          _buildMenuListTile(Icons.home, "Home", () {}),
          _buildMenuListTile(Icons.travel_explore, "Explore", () {}),
          ListTile(
            leading: const Icon(Icons.search),
            title: TextField(
              controller: searchController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          _buildMenuListTile(Icons.chat, "Chat", () {}),
          _buildMenuListTile(Icons.notifications, "Notifications", () {}),
          _buildMenuListTile(Icons.logout, "Logout", _handleLogout),
        ],
      ),
    );
  }

  Widget _buildMenuListTile(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }

  Widget _buildOrchardsList(double screenHeight, double screenWidth) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight,
      color: const Color.fromARGB(255, 227, 227, 244),
      child: FutureBuilder<List<OrchardModel>>(
        future: _orchardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          } else {
            List<OrchardModel> orchards = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(30.0),
              children: [
                const Text(
                  "My Orchards",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 67, 66, 93),
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildOrchardsListView(screenHeight, orchards),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildOrchardsListView(double screenHeight, List<OrchardModel> orchards) {
    if (orchards.isEmpty) {
      return const Center(
        child: Text(
          "No orchards available",
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return SizedBox(
      height: screenHeight * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: orchards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomOrchardTile(
              orchard: orchards[index],
            ),
          );
        },
      ),
    );
  }


  Future<List<OrchardModel>> _fetchOrchards() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = int.parse(prefs.getString("user") ?? '');

    final remoteDataSource = OrchardRemoteDataSource();
    final repository = OrchardRepositoryImpl(remoteDataSource: remoteDataSource);

    return repository.getOrchards(userId);
  }

  void _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userNickname = prefs.getString("username");
    });
  }

  void _handleLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("rememberMe", false);
    // Clear all routes and navigate to the login screen
    Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeId, (route) => false);
  }

}
