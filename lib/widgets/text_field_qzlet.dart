import 'package:flutter/material.dart';


class TextFieldQzlet extends StatelessWidget {
  const TextFieldQzlet({super.key, required this.gC, required this.fieldTag});

  final TextEditingController gC;
  final String fieldTag;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width * 0.2 + 100,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: gC,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white54,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              fieldTag,
              style: const TextStyle(
                  color: Color(0xff939BB4),
                  letterSpacing: 1,
                  fontSize: 12,
                  height: 1.333,
                  fontFamily: 'HurmeGeoSans',
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  } 

}