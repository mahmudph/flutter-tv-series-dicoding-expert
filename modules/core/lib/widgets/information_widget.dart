import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationWidget extends StatelessWidget {
  final String message, title, imageError, imageFromPackage;
  const InformationWidget({
    Key? key,
    this.title = "Something Wen't Wrong!",
    this.imageError = 'assets/page_not_found.png',
    this.imageFromPackage = 'core',
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.3,
            height: size.width * 0.3,
            child: Image.asset(
              imageError,
              package: imageFromPackage,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
