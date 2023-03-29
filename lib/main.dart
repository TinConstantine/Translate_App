import 'dart:convert';
import 'translate_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data.dart';

void main() => runApp(ChangeNotifierProvider<MySettings>(
    create: (_) => MySettings(), child: const MyApp()));

class MySettings extends ChangeNotifier {
  bool _isDark = false;
  get isDark => _isDark;
  void changeBrightness(value) {
    _isDark = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MySettings>(builder: (context, mySettings, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'SignikaNegative-Regular',
              brightness:
                  mySettings.isDark ? Brightness.dark : Brightness.light),
          home: const MyHomePage());
    });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MySettings>(builder: (context, mySettings, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Icon(mySettings.isDark
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            Switch(
              value: mySettings.isDark,
              onChanged: (value) {
                mySettings.changeBrightness(value);
              },
            )
          ],
        ),
        body: const Translate(),
      );
    });
  }
}

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  final Map<String, dynamic> _allWords =
      jsonDecode(myData); // convert myData sang kieu Map
  late List<String> _allKeys;
  @override
  void initState() {
    super.initState();
    _allKeys = _allWords.keys
        .toList(); // day toan bo key trong map allWords vao list _allKeys
  }

  final _myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _myController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                labelText: "Search",
                suffixIcon: Visibility(
                  visible: _myController.text
                      .isNotEmpty, // hien thi button xoa khi input cua textfield khac rong
                  child: IconButton(
                      onPressed: () {
                        _myController.clear();
                        setState(() {
                          _allKeys = _allWords.keys.toList();
                        });
                      },
                      icon: const Icon(Icons.clear)),
                  replacement: Icon(Icons.abc),
                )),
            onChanged: (text) {
              setState(() {
                _allKeys = _allWords.keys
                    .where((element) =>
                        element.toLowerCase().contains(text.toLowerCase()))
                    .toList(); //day cac key vao _allkey voi dieu kien key chua chu cai cua text nhap vao (phai doi ca 2 thanh chu thuong(key va text))
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          // lay tat ca phan con du
          Expanded(
              child: ListView.builder(
                  itemCount: _allKeys.length,
                  itemBuilder: (context, index) {
                    final String keys = _allKeys[
                        index]; // keys dai dien cho tung thang _allkeys
                    return InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TranslateItem(
                                  word: keys,
                                  definition: _allWords[keys][0],
                                  pronounce: _allWords[keys][1]),
                            ));
                      },
                      child: ListTile(
                        title: Text(
                          keys,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          _allWords[keys][0],
                          style: const TextStyle(fontSize: 15),
                        ), // sau key con 2 phan ( sau la list)  la dich va phien am lay dich => [0]
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
