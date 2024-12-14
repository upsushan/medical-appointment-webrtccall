import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/login_provider.dart';
import 'package:medical/provider/user_provider.dart';
LoginUser? _appUser;
class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext) builder;
   WrapperBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    _appUser = Provider.of<LoginUser?>(context);

    //Initial setup of streams and notifiers to be used in main();

    if (_appUser == null) {
      return MultiProvider(
        providers: [
          StreamProvider<LoginUser?>.value(
            value: FirestoreProvider().getLoginUser,
            initialData: LoginUser(),
          ),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        builder: (context, vm) => builder(context),
      );
    }
    return builder(context);
  }
}
