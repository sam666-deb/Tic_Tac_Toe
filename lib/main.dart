import 'package:flutter/material.dart';
import 'package:tictactoe/ui/theme/colors.dart';
import 'package:tictactoe/utils/logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  Logic logic = Logic();

  @override
  void initState() {
    super.initState();
    logic.board = Logic.initGameBoard();
    print(logic.board);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        centerTitle: true,
        backgroundColor: MainColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} turn".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              width: width,
              height: width,
              child: GridView.count(
                crossAxisCount: Logic.boardlenth ~/ 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(
                  Logic.boardlenth,
                  (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              if (logic.board![index] == "") {
                                setState(() {
                                  logic.board![index] = lastValue;
                                  turn++;
                                  gameOver = logic.winnerCheck(
                                      lastValue, index, scoreboard, 3);

                                  if (gameOver) {
                                    result = "$lastValue is the Winner";
                                  } else if (!gameOver && turn == 9) {
                                    result = "It's a Draw!";
                                    gameOver = true;
                                  }
                                  if (lastValue == "X")
                                    lastValue = "O";
                                  else
                                    lastValue = "X";
                                });
                              }
                            },
                      child: Container(
                        width: Logic.blocSize,
                        height: Logic.blocSize,
                        decoration: BoxDecoration(
                          color: MainColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            logic.board![index],
                            style: TextStyle(
                              color: logic.board![index] == "X"
                                  ? Colors.blueAccent
                                  : Colors.redAccent,
                              fontSize: 58.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            result,
            style: TextStyle(
              color: Colors.white,
              fontSize: 54,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                //erase the board
                logic.board = Logic.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: Icon(
              Icons.replay,
              color: MainColor.accentColor,
            ),
            label: Text("Restart The Game."),
          )
        ],
      ),
    );
  }
}
