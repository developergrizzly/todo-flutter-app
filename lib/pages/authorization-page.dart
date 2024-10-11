import 'package:flutter/material.dart';
import 'package:myapp/pages/home-page.dart';
import 'package:myapp/pages/sign-in-page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getAuth();
  }

  Future<void> _getAuth() async {
    setState(() {
      _user = supabase.auth.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? SignInPage() : HomePage();
  }
}
