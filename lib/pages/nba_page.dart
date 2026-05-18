import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbaapp/model/team.dart';

class NbaPage extends StatefulWidget {
  const NbaPage({super.key});

  @override
  State<NbaPage> createState() => _NbaPageState();
}

class _NbaPageState extends State<NbaPage> {
  @override
  void initState() {
    super.initState();
    getTeams();
  }

  //final
  List<Team> teams = [];

  Future getTeams() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/nba/v1/games'),
      headers: {'Authorization': '690578ec-8536-44c0-8b23-fb435becb89c'},
    );
    var jsonBody = jsonDecode(response.body);
    for (var eachTeam in jsonBody['data']) {
      final team = Team(
        city: eachTeam?['city'],
        abbreviation: eachTeam?['abbreviation'],
      );
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Home'), centerTitle: true));
  }
}
