import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuwares/models/user.dart';
// import 'package:wuwares/screens/admin/admin_dashboard.dart';

final GoogleSignIn signIn = GoogleSignIn.instance;

Future<void> initGoogle() async{
  await signIn.initialize(
    serverClientId: '801994355249-rh2uutocrbjpco0e6kb5o3psluf23lu3.apps.googleusercontent.com'
  );
}

Future<(bool, String)> googleLogin(String selectedrole) async{
  final GoogleSignInAccount acc = await signIn.authenticate();
  final user = acc.authentication;
  var response = await post(Uri.parse("http:10.0.2.2:3000/users/login"),
  headers: {"Content-Type": "application/json"},
  body: jsonEncode({
    "google_token" : user.idToken,
    'role' : selectedrole,
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


Future<dynamic> getProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  var response = await get(Uri.parse("http://10.0.2.2:3000/users/profile"),
    headers: {"authorization" : "Bearer $token"}
  );
  var result = jsonDecode(response.body);
  if(response.statusCode == 200){
    // print(result);
    return User.fromJson(result);
  } else{
    return result;
  }
}

