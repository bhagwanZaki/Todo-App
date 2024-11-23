import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';

class EditProfile extends StatefulWidget {
  final String username;
  final String email;
  final String fullname;

  const EditProfile(
      {super.key,
      required this.username,
      required this.email,
      required this.fullname});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // stream
  AuthStream? _stream;

  // form key
  final _formKey = GlobalKey<FormState>();

  // foocus node
  FocusNode fullNameFieldFocus = FocusNode();
  FocusNode emailFieldFocus = FocusNode();

  // controller
  TextEditingController username = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();

  // show error status
  bool apiCallDone = true;
  @override
  void initState() {
    username.text = widget.username;
    fullname.text = widget.fullname;
    email.text = widget.email;
    _stream = AuthStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<ApiResponse<UserModel>>(
        stream: _stream?.authStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return loadingFloatingActionBtn();
              case Status.DONE:
                apiCallDone
                    ? WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Navigator.pop(context),
                      )
                    : null;
                apiCallDone = false;
                return floatingActionBtn();
              case Status.ERROR:
                apiCallDone
                    ? Fluttertoast.showToast(
                        msg: snapshot.data!.msg,
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: AppColor.red,
                        textColor: AppColor.white,
                      )
                    : null;
                apiCallDone = false;
                return floatingActionBtn();
              default:
                return floatingActionBtn();
            }
          }
          return floatingActionBtn();
        },
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Common.isMediumScreen(context) ? 16 : 8),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text("Edit your profile details"),
                const SizedBox(
                  height: 28,
                ),
                Text(
                  "Username",
                  style: TextStyle(color: AppColor.white.withOpacity(0.7)),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: username,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(emailFieldFocus),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Email",
                  style: TextStyle(color: AppColor.white.withOpacity(0.7)),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  focusNode: emailFieldFocus,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(fullNameFieldFocus),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Full Name",
                  style: TextStyle(color: AppColor.white.withOpacity(0.7)),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  focusNode: fullNameFieldFocus,
                  controller: fullname,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(emailFieldFocus),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ],
            )),
      ),
    );
  }

  FloatingActionButton floatingActionBtn() {
    return FloatingActionButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_formKey.currentState!.validate()) {
          bool isUsernameChanged = username.text != widget.username;
          bool isFullnameChanged = fullname.text != widget.fullname;
          bool isEmailChanged = email.text != widget.email;
          if (isUsernameChanged || isFullnameChanged || isEmailChanged) {
            var obj = {
              "username": isUsernameChanged ? username.text : "",
              "fullname": isFullnameChanged ? fullname.text : "",
              "email": isEmailChanged ? email.text : "",
            };

            apiCallDone = true;
            _stream?.updateUserProfile(context.read<AuthProvider>(), obj);
          }
        }
      },
      child: Icon(Icons.check),
    );
  }

  FloatingActionButton loadingFloatingActionBtn() {
    return FloatingActionButton(
      onPressed: () {},
      child: CircularProgressIndicator(
        color: AppColor.blue,
      ),
    );
  }
}
