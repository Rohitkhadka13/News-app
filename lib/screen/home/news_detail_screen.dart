import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDescription;
  final String newsDate;
  final String newsAuthor;
  final String newsContent;
  final String newsSource;

  const NewsDetailScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDescription,
    required this.newsDate,
    required this.newsAuthor,
    required this.newsContent,
    required this.newsSource,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

final format = DateFormat("dd-MM-yyyy");

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    DateTime dateTime = DateTime.parse(widget.newsDate);
    String fullContent =
        widget.newsContent.replaceAll(RegExp(r"\[\+\d+ chars\]"), '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * 0.4),
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.newsSource,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  widget.newsDescription,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  fullContent,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
