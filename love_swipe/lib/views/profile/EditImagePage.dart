import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love/services/UserService.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../components/build_appbar.dart';
import '../../components/display_widget.dart';
import '../../models/UserModel.dart';

class EditImagePage extends StatefulWidget {
  UserModel user;

  EditImagePage(this.user, {Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  late UserModel user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Profil Fotoğrafı Düzenle"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () async {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (image == null) return;

                final location = await getApplicationDocumentsDirectory();
                final name = basename(image.path);
                final imageFile = File('${location.path}/$name');
                final newImage = await File(image.path).copy(imageFile.path);

                setState(() => user.profilePhoto = newImage.path);
                UserService userService = UserService();
                await userService.updateProfilePhoto(
                    user.id, user.profilePhoto ?? "assets/default_photo.png");
              },
              child: user.profilePhoto == null
                  ? Image.asset("assets/default_photo.png")
                  : DisplayImage(
                      imagePath: user.profilePhoto!,
                      onPressed: () {},
                    ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Güncelle',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
