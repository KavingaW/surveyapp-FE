import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveyapp/service/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';
import '../widgets/logout_widget.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.adminDashboard),
        automaticallyImplyLeading: false,
        actions: [
          LogoutButton(onLogout: () {
            showDialog(
              context: context,
              builder: (_) => ConfirmationDialog(
                onConfirm: () async {
                  ConfirmationResponseMessage.show(
                    context,
                    AppConstants.logoutMessage,
                  );
                  Navigator.pop(context);
                  AuthService authService = AuthService();
                  authService.logOut();
                  Navigator.pushReplacementNamed(context, '/loginScreen');
                },
                operation: AppConstants.operationLogout,
                message: AppConstants.messageLogout,
              ),
            );
          }),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(AppConstants.edgeInsetsValue),
          mainAxisSpacing: AppConstants.mainAxisSpacing,
          crossAxisSpacing: AppConstants.crossAxisSpacing,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/userslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.person, size: 80.0, color: Colors.indigo),
                    SizedBox(height: AppConstants.sizedBoxSizesHeight),
                    Text(AppConstants.userTileName,style: const TextStyle(fontSize: 25.0,fontFamily: 'AlfaStableOne'),),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/surveyslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.assignment, size: 80.0, color: Colors.indigo),
                    SizedBox(height: AppConstants.sizedBoxSizesHeight),
                    Text(AppConstants.surveyTileName,style: const TextStyle(fontSize: 25.0,fontFamily: 'AlfaStableOne'),),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/resultslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.poll, size: 80.0, color: Colors.indigo),
                    SizedBox(height: AppConstants.sizedBoxSizesHeight),
                    Text(AppConstants.resultTileNme, style: const TextStyle(fontSize: 25.0,fontFamily: 'AlfaStableOne',),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
