import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:validate_tokens/src/pages/get_inavlid_tokens_page.dart';
import 'package:validate_tokens/src/pages/get_valid_tokens_page.dart';

class MenuPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              height: 50.0,
              minWidth: 400.0,
              color: Colors.blue,
              child: Text('Input valid tokens'),
              onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => GetValidTokensPage()))
            ),
            SizedBox( height: 20.0, ),
            MaterialButton(
              height: 50.0,
              minWidth: 400.0,
              color: Colors.blue,
              child: Text('Input invalid tokens'),
              onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => GetInvalidTokensPage()))
            ),
          ],
        ),
     ),
   );
  }
}