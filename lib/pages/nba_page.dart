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

  late Future<void> teamData;

  @override
  void initState() {
    super.initState();
    teamData = getTeams();
  }

  Future<void> getTeams() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/nba/v1/teams'),
      headers: {'Authorization': '690578ec-8536-44c0-8b23-fb435becb89c'},
    );
    //clearing teams interms of rebuild
    teams.clear();

    var jsonBody = jsonDecode(response.body);
    for (var game in jsonBody['data']) {
      final city = game['city'];
      if (city == null || city.toString().isEmpty) continue;

      final team = Team(city: city, abbreviation: game['abbreviation']);
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(teams[index].city ?? 'Error'),

                visualDensity: VisualDensity.compact,
                subtitle: Text(teams[index].abbreviation ?? 'error'),
              );
            },
          );
        },
      ),
    );
  }
}
