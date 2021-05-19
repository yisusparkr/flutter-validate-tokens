import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validate_tokens/src/providers/tokens_provider.dart';

class GetInvalidTokensPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final tokensProvider = Provider.of<TokensProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            splashRadius: 20.0,
            icon: Icon(Icons.arrow_back_ios_rounded), 
            onPressed: () {
              Navigator.pop(context);
              tokensProvider.userReadyToValidate = false;
              tokensProvider.userText = '';
              tokensProvider.characters = '';
            } 
          ),
        ),
        body: Center(
          child: AnimatedContainer(
            height: tokensProvider.userReadyToValidate ? 500.0 : 300.0 ,
            duration: const Duration( milliseconds: 200 ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Input your invalid tokens', style: GoogleFonts.abel( fontSize: 30.0, color: Colors.white ), ),
                  SizedBox( height: 20.0 ),
                  Container(
                    margin: const EdgeInsets.symmetric( horizontal: 20.0 ),
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                      minWidth: 250.0
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tokens'
                      ),
                      onTap: () {
                        tokensProvider.userReadyToValidate = false;
                        tokensProvider.userText = '';
                      },
                      onChanged: (value) => tokensProvider.characters = value,
                    ),
                  ),
                  SizedBox( height: 20.0 ),
                  AnimatedSwitcher(
                    duration: const Duration( milliseconds: 300 ),
                    child: !tokensProvider.userReadyToValidate ?
                    MaterialButton(
                      height: 50.0,
                      minWidth: 250.0,
                      color: Colors.blue,
                      child: Text('Save tokens', style: TextStyle( color: Colors.white ),),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if( tokensProvider.characters.isNotEmpty ) tokensProvider.saveTokens();
                      }
                    )
                    : SizedBox( height: 40.0, )
                  ),
                  SizedBox( height: 10.0 ),
                  AnimatedSwitcher(
                    duration: const Duration( milliseconds: 300 ),
                    child: tokensProvider.userReadyToValidate ? 
                    Container(
                      child: Column(
                        children: [
                          Text('Write your text', style: GoogleFonts.abel( fontSize: 30.0, color: Colors.white ), ),
                          SizedBox( height: 20.0 ),
                          Container(
                            margin: const EdgeInsets.symmetric( horizontal: 20.0 ),
                            constraints: BoxConstraints(
                              maxHeight: 100.0,
                              minHeight: 70.0,
                              maxWidth: 600.0,
                              minWidth: 250.0
                            ),
                            child: TextField(
                              maxLines: 30,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Text'
                              ),
                              onChanged: (value) => tokensProvider.userText = value,
                            ),
                          ),
                          SizedBox( height: 20.0 ),
                          MaterialButton(
                            height: 50.0,
                            minWidth: 250.0,
                            color: Colors.blue,
                            child: Text('Validate', style: TextStyle( color: Colors.white ),),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if( tokensProvider.userText.isEmpty || tokensProvider.userText.contains('  ') ){
                                showCustomSnackBar(
                                  context,
                                  Icon(Icons.close, color: Colors.red,),
                                  !tokensProvider.userText.contains('  ') 
                                    ? 'Write some text'
                                    : 'You cant\'t use more than one blank space'
                                );
                              }
                              else {
                                bool hasInvalidTokens = false;
                                tokensProvider.tokens.map((token) {
                                  if( tokensProvider.userText.contains(token) ) hasInvalidTokens = true;
                                }).toList();

                                if( !hasInvalidTokens ){
                                  showCustomSnackBar(
                                    context,
                                    Icon(Icons.check, color: Colors.green,),
                                    'The text doesn\'t contains invalid tokens'
                                  );
                                } else{
                                  validateText(context);
                                }

                              }
                            }
                          )
                        ],
                      ),
                    )
                    : SizedBox()
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  void validateText( BuildContext context ){

    final tokensProvider = Provider.of<TokensProvider>(context, listen: false);

    Map<String, List<String>> words = {};
    List<String> tokens = [];
    List<String> userWords = tokensProvider.userText.split(' ');
    List<String> wrongWords = [];

    userWords.forEach((element) { 
      words.update(element, (value) => null, ifAbsent: () => words[element] = [] );
    });
    tokensProvider.tokens.map((e) {
      userWords.forEach((element) {
        if( element.contains('$e') ){
          tokens = words[element];
          tokens.add(e);
          words[element] = tokens;
        }
      });
    }).toList();

    words.forEach((key, values) { 
      if( values.isNotEmpty ){
        final value = '$key contains ${values.map((e) => e)}';
        wrongWords.add(value);
      }
    });

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Wrong words', style: GoogleFonts.abel( fontSize: 23.0, color: Colors.black87, fontWeight: FontWeight.bold ))
          ),
          content: Container(
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              itemCount: wrongWords.length,
              itemBuilder: ( _ , index ){
                return Text('${wrongWords[index]}', style: GoogleFonts.abel( fontSize: 18.0, color: Colors.black87 ));
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop()
            )
          ],
        );
      },
    );

  }

  void showCustomSnackBar( BuildContext context, Icon icon, String description ){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5.0) ),
        padding: const EdgeInsets.symmetric( horizontal: 10.0 ),
        content: Row(
          children: [
            icon,
            SizedBox( width: 5.0 ),
            Text(description, style: GoogleFonts.abel( fontSize: 20.0, color: Colors.white),)
          ],
        )
      )
    );
  }

}