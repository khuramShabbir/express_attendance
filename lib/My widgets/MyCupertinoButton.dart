import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCupertinoButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;
  final double width;
  final double padding;
  final double textSize;
  final bool enabled;

  const MyCupertinoButton({ Key? key, required this.text, required this.onPressed, required this.width,required this.textSize,required this.padding, this.enabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
      child: CupertinoButton.filled(

          child: Text(text),
         padding: padding!=null?EdgeInsets.all(12):EdgeInsets.symmetric(
           vertical: 14.0,
           horizontal: 64.0,
         ),
          disabledColor:Colors.grey ,



        onPressed: !enabled ? null : onPressed,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
