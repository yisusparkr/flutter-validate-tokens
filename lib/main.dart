import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validate_tokens/src/pages/menu_page.dart';
import 'package:validate_tokens/src/providers/tokens_provider.dart';
 
void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => TokensProvider(),
    child: MyApp()
  ));
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Validate Tokens',
      home: MenuPage(),
      theme: ThemeData.dark(),
    );
  }
}