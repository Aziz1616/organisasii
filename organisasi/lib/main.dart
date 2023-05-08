import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organisasi/servisler/yetkilendirmeServisi.dart';
import 'package:organisasi/yonlendirme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => YetkilendirmeServisi(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Origanisasi',
        home: Yonlendirme(),
      ),
    );
  }
}
