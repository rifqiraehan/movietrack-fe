import 'package:flutter/material.dart';
import 'package:movietrack/list_widget/review_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        ReviewCard(
          title: "Fate/Stay Night",
          reviewText: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde alias magni ipsa omnis nemo deserunt illo",
          reviewerImage: "https://via.placeholder.com/150",
          username: "akariakaza",
          date: "30 Sept 2024",
        ),
        ReviewCard(
          title: "Who am I?",
          reviewText: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde alias magni ipsa omnis nemo deserunt illo, ratione sed sapiente veritatis corporis...",
          reviewerImage: "https://via.placeholder.com/150",
          username: "cashtoria",
          date: "28 Sept 2024",
        ),
      ],
    );
  }
}