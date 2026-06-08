import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn signIn = GoogleSignIn.instance;

Future<void> initGoogle() async{
  await signIn.initialize(
    serverClientId: '801994355249-rh2uutocrbjpco0e6kb5o3psluf23lu3.apps.googleusercontent.com'
  );
}

Future<(bool, String)> googleLogin() async{
  final GoogleSignInAccount acc = await signIn.authenticate();
  final user = acc.authentication;
  var response = await post(Uri.parse("http:localhost/users/login"),
  headers: {"Content-Type": "applications/json"},
  body: jsonEncode({
    "google_token" : user.idToken,
    'role' : _selectedRole,
    })
  ); 
  var result = jsonDecode(response.body);
  if(response.statusCode == 200){
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", result['token'].toString());
    return (true, "");
  }
  return (false, result['message'].toString());
}

