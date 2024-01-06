import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:open_search/env/env.dart';

/// Flutter code sample for [Card].

class MapZoomGuildLine extends StatefulWidget {
  final SearchResult searchedTarget;
  const MapZoomGuildLine({super.key, required this.searchedTarget});

  @override
  State<MapZoomGuildLine> createState() => MapZoomGuildLineState();
}

class MapZoomGuildLineState extends State<MapZoomGuildLine> {
  final String apiKey = Env.key;

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
