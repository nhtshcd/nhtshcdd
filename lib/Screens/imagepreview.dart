import 'dart:io';

import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  File imageFile1;
  ImageDialog(this.imageFile1);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
        width: MediaQuery.of(context).size.width,
        height: 600,
        child: Image.file(
            imageFile1,
          ),
      )
    );
  }

}