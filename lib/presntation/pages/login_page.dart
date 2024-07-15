import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dakhalia_project/presntation/pages/dashboard_page.dart';
import 'package:dakhalia_project/presntation/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routeId = "login-page";
  bool? rememberMe = false;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool("rememberMe")!;
      if (rememberMe) {
        usernameController.text = prefs.getString("username") ?? "";
      }
    });
  }

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });

    _authenticate(context);

    setState(() {
      isLoading = false;
    });
  }

  void _authenticate(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'mytestdb',
          username: 'postgres',
          password: 'Asdasd12\$12',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await connection.execute(
        'SELECT username,password,id FROM users where username = \'$_username\'',
      );
      String hashedPassword = _encryptPassword(_password as String);
      if (result.isNotEmpty) {
        if (hashedPassword != result[0][1]) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Wrong password")));
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var userId = result[0][2];
          prefs.setString("user", userId.toString());
          prefs.setString("username", _username.toString());
          prefs.setBool("rememberMe", rememberMe);
          Navigator.of(context).pushReplacementNamed(DashboardPage.routeId);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Username not found")));
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.4,
              height: screenHeight,
              child: Image.asset(
                "assets/background.jpg",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Welcome back! Please log in to your account.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SansPro',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.15, vertical: 15),
                      child: CustomTextFormField(
                        hint: "Username",
                        onClick: (value) {
                          _username = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.15, vertical: 15),
                      child: CustomTextFormField(
                        hint: "Password",
                        onClick: (value) {
                          _password = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.black,
                                  value: widget.rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.rememberMe = value;
                                      rememberMe = value ?? false;
                                    });
                                  }),
                              const Text("Remember me",style: TextStyle(fontFamily: 'SansPro',),)
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Implement forgot password logic here
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xFF43425D),fontFamily: 'SansPro',),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.29,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color.fromARGB(255, 67, 66, 93),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // Implement terms of use logic here
                          },
                          child: Text(
                            'Term of use.',
                            style: TextStyle(
                              fontFamily: 'SansPro',
                              fontSize: 12,
                              color: Color(0xFF43425D),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // Implement privacy policy logic here
                          },
                          child: Text(
                            'Privacy policy',
                            style: TextStyle(
                              fontFamily: 'SansPro',
                              fontSize: 12,
                              color: Color(0xFF43425D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
