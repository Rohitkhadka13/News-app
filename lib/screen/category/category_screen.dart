import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/screen/home/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

NewsViewModel newsViewModel = NewsViewModel();

final format = DateFormat("dd-MM-yyyy");

String category = "general";

List<String> categoriesList = [
  "General",
  "Business",
  "Entertainment",
  "Health",
  "Science",
  "Sports",
  "Technology"
];

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        category = categoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: category == categoriesList[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Center(
                                child: Text(
                              categoriesList[index],
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriiesNews(category),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitDancingSquare(
                          color: Colors.blue,
                          size: 40,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            DateTime date = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetailScreen(
                                                newsImage: snapshot.data!
                                                    .articles![index].urlToImage
                                                    .toString(),
                                                newsTitle: snapshot.data!
                                                    .articles![index].title
                                                    .toString(),
                                                newsDescription: snapshot
                                                    .data!
                                                    .articles![index]
                                                    .description
                                                    .toString(),
                                                newsDate: snapshot
                                                    .data!
                                                    .articles![index]
                                                    .publishedAt
                                                    .toString(),
                                                newsAuthor: snapshot.data!
                                                    .articles![index].author
                                                    .toString(),
                                                newsContent: snapshot.data!
                                                    .articles![index].content
                                                    .toString(),
                                                newsSource: snapshot
                                                    .data!
                                                    .articles![index]
                                                    .source!
                                                    .name
                                                    .toString(),
                                              )));
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height: height * 0.18,
                                        width: width * 0.3,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spinKit,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: height * 0.18,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Text(
                                                format.format(date),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

const spinKit = SpinKitChasingDots(
  color: Colors.blue,
  size: 40,
);
