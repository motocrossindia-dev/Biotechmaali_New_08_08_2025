// import 'dart:developer';
// import '../../import.dart';

// enum _Key {
//   isAllreadyRegistered,
//   isLoggedIn,
//   access_token,
// }

// class LocalStorageService extends ChangeNotifier {
//   SharedPreferences? _sharedPreferences;

//   // init should initialize through cunstructor when local storage service call
//   LocalStorageService() {
//     init();
//   }
// /* initializing shared preference */
//   Future<LocalStorageService> init() async {
//     _sharedPreferences = await SharedPreferences.getInstance();
//     return this;
//   }

//   // ***************************************************************************

// //
//   /* Store and get the login state of user */

//   bool get isLoggedIn {
//     var res = _sharedPreferences?.getBool(_Key.isLoggedIn.toString());
//     return res ?? false;
//   }

//   setIsLoggedIn(bool state) {
//     _sharedPreferences?.setBool(_Key.isLoggedIn.toString(), state);
//   }

// // ***************************************************************************
// /* Check the token status and store, get and remove the token   */

//   String get token {
//     var res = _sharedPreferences?.getString(_Key.access_token.toString());
//     log("Token status: $res");
//     return res ?? "invalid";
//   }

//   setToken(String token) {
//     _sharedPreferences?.setString(_Key.access_token.toString(), token);
//   }

//   removeToken() {
//     _sharedPreferences?.remove(_Key.access_token.toString());

//     log('Removed Token: ${_sharedPreferences?.getString(_Key.access_token.toString())}');
//   }

// // ***************************************************************************

// /* Check the user allready registered or not registered */
//   bool get isAllreadyRegistered {
//     var res = _sharedPreferences?.getBool(_Key.isAllreadyRegistered.toString());
//     return res ?? false;
//   }

//   setIsAllreadyRegistered(bool state) {
//     _sharedPreferences?.setBool(_Key.isAllreadyRegistered.toString(), state);
//   }
// }
