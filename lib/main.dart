import 'package:flutter/material.dart';
import 'package:flutter_wallet/auth_provider.dart';
import 'package:flutter_wallet/signin.dart';
import 'package:flutter_wallet/wallet_services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginRealm>(create: (context) => LoginRealm()),
        ChangeNotifierProvider<WalletServices>(
          create: (context) => WalletServices(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignIn2(),
      ),
    );
  }
}
