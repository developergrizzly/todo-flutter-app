import 'package:flutter/material.dart';
import 'package:myapp/pages/authorization-page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  String supabaseUrl = 'https://jfgmsdglfuymnhpoggue.supabase.co';
  String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmZ21zZGdsZnV5bW5ocG9nZ3VlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg2MjIxMjIsImV4cCI6MjA0NDE5ODEyMn0.jvficyNaF5cJFQQWpTFExYH6fo5rVmwXMkQdqLQeMHg';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthorizationPage(),
    );
  }
}
