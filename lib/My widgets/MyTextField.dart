import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTextField extends StatefulWidget {
  final bool obscuretxt;
  final double heigtContainer;
  final String hintTxt;
  final IconData? IconLeft;
  final dynamic IconRight;
  final TextEditingController textEditingController;
  final bool enabled;
  final TextInputType textInputType;
  final String? Function(String?)? onValidate;
  final int mxLine;
  final FocusNode? focusNode;

  const MyTextField(
      {Key? key,
      this.obscuretxt = false,
      this.focusNode,
      required this.hintTxt,
      this.IconLeft,
      this.IconRight,
      required this.textEditingController,
      this.enabled = true,
      this.textInputType = TextInputType.text,
      this.onValidate,
      required this.mxLine,
      required this.heigtContainer})
      : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Container(
      height: widget.heigtContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          focusNode: widget.focusNode,
          maxLines: widget.mxLine,
          controller: widget.textEditingController,
          enabled: widget.enabled,
          keyboardType: widget.textInputType,
          onFieldSubmitted: (value) {},
          validator: widget.onValidate,
          obscureText: widget.obscuretxt,
          decoration: InputDecoration(
            // focusColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 1.5,
              color: HexColor("#D9D9D9").withOpacity(0.8),
            )),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#D9D9D9").withOpacity(0.8), width: 1.5),
              // borderRadius: BorderRadius.circular(10.0),
            ),

            // border:  OutlineInputBorder(
            //
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(10),
            //   ),
            //   // borderSide: BorderSide.none,
            //   borderSide: BorderSide(
            //       color: HexColor("#D9D9D9").withOpacity(0.4), width: 2.0
            //   ),
            //
            // ),
            filled: true,
            fillColor: Colors.white,
            // fillColor: Colors.blueGrey[50],

            // errorText: widget.errorText,

            //  border: OutlineInputBorder(
            //      borderSide: BorderSide(color: Colors.red),
            //      borderRadius: BorderRadius.circular(15),
            // ),
            // disabledBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.red),
            //     borderRadius: BorderRadius.circular(15)
            // ),
            // focusedBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.red),
            //     borderRadius: BorderRadius.circular(15)
            // ),
            // focusColor: Colors.red,
            hintText: widget.hintTxt,
            hintStyle: const TextStyle(color: Colors.black38),
            // prefixIcon:widget.,
            suffixIcon: widget.IconRight,
            // enabledBorder: UnderlineInputBorder(
            //   // borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
            // ),
            // focusedBorder: UnderlineInputBorder(
            //   // borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
            // ),
          ),
        ),
      ),
    );
  }
}
