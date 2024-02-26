import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jwèt Panch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: MonApp(),
    );
  }
}

class MonApp extends StatefulWidget {
  const MonApp({Key? key});

  @override
  State<MonApp> createState() => _MonAppState();
}

class _MonAppState extends State<MonApp> {
  final Map<String, String> mots = {
    "Flutter": "Yon platfòm pou kreye aplikasyon andwad oswa ios",
    "Pomme": "yon fwi ki bèl anpil.",
    "Voiture": "Yon mwayen transpò a kat pye.",
    "Ordinateur": "Yon aparèy elektwonik ki sèvi pou tretman enfòmasyon.",
  };

  late String moKache;
  late String deskripsyon;
  int chances = 5;
  List<String> lettresDevinees = [];
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    choisirMotAleatoire();
  }

  void choisirMotAleatoire() {
    final random = Random();
    final index = random.nextInt(mots.length);
    setState(() {
      moKache = mots.keys.elementAt(index).toLowerCase();
      deskripsyon = mots[moKache.capitalizeFirstLetter()]!;
    });
  }

  void verifierLettre(String lettre) {
    setState(() {
      if (!moKache.contains(lettre.toLowerCase())) {
        chances--;
        if (chances == 0) {
          gameOver = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultatPage(aGagne: false),
            ),
          );
        }
      }
      if (!gameOver) {
        if (!lettresDevinees.contains(lettre.toLowerCase())) {
          lettresDevinees.add(lettre.toLowerCase());
          if (moKache.split('').every((char) => lettresDevinees.contains(char))) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultatPage(aGagne: true),
              ),
            );
          }
        }
      }
    });
  }

  Widget buildLettreButton(String lettre) {
    return ElevatedButton(
      onPressed: () {
        verifierLettre(lettre);
      },
      child: Text(lettre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hangman"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(chances.toString()),
                SizedBox(width: 4),
                Icon(Icons.star)
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                moKache.replaceAllMapped(
                  RegExp(r'[a-z]'),
                  (match) {
                    var char = match.group(0)!;
                    if (lettresDevinees.contains(char)) {
                      return char;
                    } else {
                      return '*';
                    }
                  },
                ),
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text("Deskripsyon : $deskripsyon"),
              if (gameOver) Text("Ou pedi !"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLettreButton("A"),
                buildLettreButton("B"),
                buildLettreButton("C"),
                buildLettreButton("D"),
                buildLettreButton("E"),
                buildLettreButton("F"),
                buildLettreButton("G"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLettreButton("H"),
                buildLettreButton("I"),
                buildLettreButton("J"),
                buildLettreButton("K"),
                buildLettreButton("L"),
                buildLettreButton("M"),
                buildLettreButton("N"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLettreButton("O"),
                buildLettreButton("P"),
                buildLettreButton("Q"),
                buildLettreButton("R"),
                buildLettreButton("S"),
                buildLettreButton("T"),
                buildLettreButton("U"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLettreButton("V"),
                buildLettreButton("W"),
                buildLettreButton("X"),
                buildLettreButton("Y"),
                buildLettreButton("Z"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultatPage extends StatelessWidget {
  final bool aGagne;

  const ResultatPage({Key? key, required this.aGagne}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(aGagne ? "Félicitations !" : "Dommage..."),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(aGagne ? "Ou genyen !" : "Ou pedi !"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/')); // Redirige sou paj prensipal la
              },
              child: Text("Jwe ankò"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // Fèmen aplikasyon an
              },
              child: Text("Kwoke"),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}
