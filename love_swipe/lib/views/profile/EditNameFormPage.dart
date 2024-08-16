import 'package:flutter/material.dart';
import 'package:love/models/UserModel.dart';
import 'package:love/services/UserService.dart';

import '../../components/build_appbar.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  UserModel user;
  EditNameFormPage(this.user,{Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  late UserModel user;

  @override
  void initState() {
    user = widget.user;
    firstNameController.text = user.username;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  Future<void> updateUserValue(String name) async {
    user.username = name;
    UserService userService = UserService();
    await userService.updateUsername(user.id, user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context,"Kullanıcı adını düzenle"),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(24),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Adınızı girin';
                      }
                      return null;
                    },
                    decoration:
                    InputDecoration(labelText: 'Adınız'),
                    controller: firstNameController,
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await updateUserValue(firstNameController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Güncelle',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ],
          ),
        ));
  }
}