import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "";
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController nameController = TextEditingController();
  bool isNameSet = false;
  Timer? winConditionTimer;
  bool hasWon = false;
  bool hasLost = false;
  
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkLossCondition();
      });
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkWinCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel >= 80) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel == 100) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void _checkWinCondition() {
    if (happinessLevel > 80) {
      winConditionTimer ??= Timer(Duration(minutes: 3), () {
        setState(() {
          hasWon = true;
        });
      });
    } else {
      winConditionTimer?.cancel();
      winConditionTimer = null;
    }
  }

  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        hasLost = true;
      });
    }
  }

  Color _getPetGlowColor() {
    if (happinessLevel > 70) {
      return Colors.green.withOpacity(0.5);
    } else if (happinessLevel >= 30) {
      return Colors.yellow.withOpacity(0.5);
    } else {
      return Colors.red.withOpacity(0.5);
    }
  }

  String _getMoodText() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  void _setPetName() {
    setState(() {
      petName = nameController.text;
      isNameSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Center(
        child: hasWon
            ? Text("Congratulations! You won! 🎉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            : hasLost
                ? Text("Game Over! 😢", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                : isNameSet
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getPetGlowColor(),
                                  blurRadius: 30,
                                  spreadRadius: 15,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.asset(
                                  'assets/EggDog.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Image not found');
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 16.0),
                          Text('Mood: ${_getMoodText()}',
                              style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 16.0),
                          Text('Happiness Level: $happinessLevel',
                              style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 16.0),
                          Text('Hunger Level: $hungerLevel',
                              style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: _playWithPet,
                            child: Text('Play with Your Pet'),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _feedPet,
                            child: Text('Feed Your Pet'),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Enter your pet's name:",
                              style: TextStyle(fontSize: 18.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), hintText: 'Pet Name'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _setPetName,
                            child: Text('Confirm Name'),
                          ),
                        ],
                      ),
      ),
    );
  }
}