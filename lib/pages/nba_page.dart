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
  //final
  List<Team> teams = [];

  late Future<dynamic> teamData;

  @override
  void initState() {
    super.initState();
    teamData = getTeams();
  }

  Future getTeams() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/nba/v1/games'),
      headers: {'Authorization': '690578ec-8536-44c0-8b23-fb435becb89c'},
    );
    //clearing teams interms of rebuild
    teams.clear();

    var jsonBody = jsonDecode(response.body);
    for (var game in jsonBody['data']) {
      final team = Team(
        city: game['home_team']['city'],
        abbreviation: game['home_team']['abbreviation'],
      );
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), centerTitle: true),
      body: FutureBuilder(
        future: teamData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //if connectionstate waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //if error
          if (snapshot.hasError) {
            return Center(
              child: const Text('There has been an error, please try again'),
            );
          }

          //if has data
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text(teams[index].city ?? 'Error'));
            },
          );
        },
      ),
    );
  }
}
