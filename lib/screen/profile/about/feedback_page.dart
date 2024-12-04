import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/common.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _editTextController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  File? uploadedImage;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Common.isMediumScreen(context) ? 80 : 0),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "To give us more context about your report, it’ll include some information about your device. If necessary, we may contact you via email to gather more details. To learn what info we use and how, check out our",
                      style: TextStyle(
                          height: 1.1,
                          fontFamily: 'Spartan',
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: AppColor.white40),
                      children: [
                        TextSpan(
                            text: " Privacy Policy",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(
                                  context, Routes.privacyPolicyScreen),
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 14,
                              color: AppColor.blue,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Spartan',
                            )),
                      ])),
            ),
            const SizedBox(
              height: 8,
            ),
            MaterialButton(
              minWidth: double.infinity,
              color: AppColor.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 0,
                    fontSize: 20,
                    color: AppColor.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
                color: AppColor.textInput,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (isImageSelected)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  uploadedImage!,
                                  // height: 400,
                                  width: 200,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: -2,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    uploadedImage = null;
                                    isImageSelected = false;
                                  });
                                },
                                child: Ink(
                                  child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.red,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                      )),
                                )),
                          )
                        ],
                      ),
                    isImageSelected
                        ? SizedBox(
                            width: 8,
                          )
                        : SizedBox(),
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        child: TextFormField(
                          controller: _editTextController,
                          maxLines: 10,
                          decoration: InputDecoration(
                              hintText: "How can we make app even better?",
                              fillColor: Colors.transparent,
                              enabledBorder: transparentTextFieldBorder(),
                              focusedBorder: transparentTextFieldBorder(),
                              errorBorder: transparentTextFieldBorder()),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    onPressed: () async {
                      var pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          uploadedImage = File(pickedFile.path);
                          isImageSelected = true;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColor.black,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "Add Attachment",
                              style: TextStyle(
                                  height: 0,
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  OutlineInputBorder transparentTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
