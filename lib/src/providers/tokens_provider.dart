import 'package:flutter/material.dart';

class TokensProvider with ChangeNotifier {

  String _characters = '';
  String _userText = '';
  List<String> _tokens = [];
  List<String> _wrongWords = [];
  bool _userReadyToValidate = false;

  String get characters => this._characters;

  set characters( String values ) {
    this._characters = values;
    notifyListeners();
  }

  String get userText => this._userText;

  set userText( String value ) {
    this._userText = value;
    notifyListeners();
  }

  List<String> get tokens => this._tokens;

  set tokens( List<String> values ) {
    this._tokens = values;
    notifyListeners();
  }

  List<String> get wrongWords => this._wrongWords;

  set wrongWords( List<String> values ) {
    this._wrongWords = values;
    notifyListeners();
  }

  bool get userReadyToValidate => this._userReadyToValidate;

  set userReadyToValidate( bool value ){
    this._userReadyToValidate = value;
    notifyListeners();
  }

  void saveTokens(){
    final values = this.characters.split('');
    List<String> newTokens = [];

    values.forEach((token) { 
      if( !newTokens.contains(token) ) newTokens.add(token);
    });
    
    this._tokens = newTokens;
    this._userReadyToValidate = true;
    notifyListeners();
  }


}