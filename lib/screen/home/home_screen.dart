import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/extension.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_headline_model.dart';
import 'package:news_app/screen/category/category_screen.dart';
import 'package:news_app/screen/home/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterSource { bbcNews, espn, bbcSport, cnn, reuters, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat("dd-MM-yyyy");

  FilterSource? selectedFilter;

  String name = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final width = context.screenWidth;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const CategoryScreen();
            }));
          },
          icon: Image.network(
            "https://cdn-icons-png.flaticon.com/128/2769/2769160.png",
            height: 35,
            width: 35,
          ),
        ),
        title: Text(
          "News ",
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterSource>(
              initialValue: selectedFilter,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (FilterSource item) {
                setState(() {
                  selectedFilter = item;

                  if (item == FilterSource.bbcNews) {
                    name = "bbc-news";
                  } else if (item == FilterSource.reuters) {
                    name = "reuters";
                  } else if (item == FilterSource.espn) {
                    name = "espn";
                  } else if (item == FilterSource.cnn) {
                    name = "cnn";
                  } else if (item == FilterSource.alJazeera) {
                    name = "al-jazeera-english";
                  }
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterSource>>[
                    const PopupMenuItem<FilterSource>(
                      value: FilterSource.bbcNews,
                      child: Text("BBC News"),
                    ),
                    const PopupMenuItem<FilterSource>(
                      value: FilterSource.reuters,
                      child: Text("Reuters"),
                    ),
                    const PopupMenuItem<FilterSource>(
                      value: FilterSource.espn,
                      child: Text("ESPN"),
                    ),
                    const PopupMenuItem<FilterSource>(
                      value: FilterSource.cnn,
                      child: Text("CNN"),
                    ),
                    const PopupMenuItem<FilterSource>(
                      value: FilterSource.alJazeera,
                      child: Text("Al-Jazeera"),
                    ),
                  ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsHeadlinesModel>(
                future: newsViewModel.fetchNewsHeadlines(name),
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
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime date = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                            newsImage: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            newsTitle: snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            newsDescription: snapshot.data!
                                                .articles![index].description
                                                .toString(),
                                            newsDate: snapshot.data!
                                                .articles![index].publishedAt
                                                .toString(),
                                            newsAuthor: snapshot
                                                .data!.articles![index].author
                                                .toString(),
                                            newsContent: snapshot
                                                .data!.articles![index].content
                                                .toString(),
                                            newsSource: snapshot.data!
                                                .articles![index].source!.name
                                                .toString(),
                                          )));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height * 0.02),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: spinKit,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        height: height * 0.22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    format.format(date),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriiesNews("general"),
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
                        shrinkWrap: true,
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
                                        builder: (context) => NewsDetailScreen(
                                              newsImage: snapshot.data!
                                                  .articles![index].urlToImage
                                                  .toString(),
                                              newsTitle: snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              newsDescription: snapshot.data!
                                                  .articles![index].description
                                                  .toString(),
                                              newsDate: snapshot.data!
                                                  .articles![index].publishedAt
                                                  .toString(),
                                              newsAuthor: snapshot
                                                  .data!.articles![index].author
                                                  .toString(),
                                              newsContent: snapshot.data!
                                                  .articles![index].content
                                                  .toString(),
                                              newsSource: snapshot.data!
                                                  .articles![index].source!.name
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
                                      placeholder: (context, url) => Container(
                                        child: spinKit,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: height * 0.18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
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
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              format.format(date),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
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
    );
  }
}

const spinKit = SpinKitChasingDots(
  color: Colors.blue,
  size: 40,
);
