import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plank/models/counter.dart';
import 'package:plank/models/pair.dart';
import 'package:rxdart/rxdart.dart';
import 'package:plank/utils.dart';
import 'package:plank/widgets/duration_box.dart';
import 'package:plank/widgets/plank_run_button.dart';
import 'package:plank/extensions.dart';

import '../plank_view_model.dart';

class PlankPage extends StatefulWidget {
  static final String route = '/';

  @override
  _PlankPageState createState() => _PlankPageState();
}

class _PlankPageState extends State<PlankPage> {
  TextEditingController _activeController;
  TextEditingController _restController;
  PlankViewModel _vm = PlankViewModel();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _vm.dispose();
    _activeController.dispose();
    _restController.dispose();
    super.dispose();
  }

  void _init() async {
    _vm.activePeriod().then((value) {
      setState(() {
        _activeController = TextEditingController(text: "$value");
      });
    });

    _vm.restPeriod().then((value) {
      setState(() {
        _restController = TextEditingController(text: "$value");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.grey[800],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 12,
        title: Text(
          "Plank",
          style: TextStyle(
            color: Colors.amber[200],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StreamBuilder<Pair<Counter, bool>>(
                      stream: Rx.combineLatest2(
                          _vm.counter, _vm.isEditing, (a, b) => Pair(a, b)),
                      builder: (context, snapshot) => !snapshot.hasData
                          ? SizedBox.shrink()
                          : DurationBox(
                              onTextChange: _vm.updateActive,
                              editable: snapshot.data.second,
                              controller: _activeController,
                              nonEditableText:
                                  'Active Period: ${snapshot.data?.first?.activeDurationSeconds}s',
                              editableHint: 'Active (sec)',
                            ),
                    ),
                    StreamBuilder<Pair<Counter, bool>>(
                      stream: Rx.combineLatest2(_vm.counter, _vm.isEditing,
                          (counter, isEditing) => Pair(counter, isEditing)),
                      builder: (context, snapshot) => !snapshot.hasData
                          ? SizedBox.shrink()
                          : DurationBox(
                              onTextChange: _vm.updateRest,
                              editable: snapshot.data.second,
                              controller: _restController,
                              nonEditableText:
                                  'Rest Period: ${snapshot.data.first.restDurationSeconds}s',
                              editableHint: 'Rest (sec)',
                            ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              StreamBuilder<bool>(
                stream: _vm.isRunning,
                builder: (context, snapshot) => !snapshot.hasData
                    ? SizedBox.shrink()
                    : ActionButton(
                        stopped: !snapshot.data,
                        function: () {
                          _vm.onButtonPressed(
                              activeSeconds: _activeController.text,
                              restSeconds: _restController.text);
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: StreamBuilder<Pair<Counter, bool>>(
                  stream: Rx.combineLatest2(
                      _vm.counter, _vm.isEditing, (a, b) => Pair(a, b)),
                  builder: (context, snapshot) => !snapshot.hasData
                      ? SizedBox.shrink()
                      : Visibility(
                          maintainState: true,
                          maintainSize: true,
                          maintainAnimation: true,
                          visible: !snapshot.data.second,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: spanned(
                              "${(snapshot.data.first.isActive ? "Plank" : "Rest").toUpperCase()}\n${snapshot.data.first.currentToString()}",
                              separator: '\n',
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: (snapshot.data.first.isActive)
                                    ? Colors.amber[200]
                                    : Colors.green[600],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<Pair<Counter, bool>>(
                    stream: Rx.combineLatest2(
                        _vm.counter, _vm.isEditing, (a, b) => Pair(a, b)),
                    builder: (context, snapshot) => !snapshot.hasData
                        ? SizedBox.shrink()
                        : Visibility(
                            maintainState: true,
                            maintainSize: true,
                            maintainAnimation: true,
                            visible: !snapshot.data.second,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: RichText(
                                text: spanned(
                                  'Plank Summary:\n${snapshot.data.first.fullActivePeriods} times, ${snapshot.data.first.plankSummaryToString()}',
                                  separator: ':\n',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.amber[200].withOpacity(0.4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  StreamBuilder<Pair<bool, bool>>(
                    stream: Rx.combineLatest2(
                        _vm.isRunning, _vm.isEditing, (a, b) => Pair(a, b)),
                    builder: (context, snapshot) => !snapshot.hasData
                        ? SizedBox.shrink()
                        : Visibility(
                            maintainState: true,
                            maintainSize: true,
                            maintainAnimation: true,
                            visible:
                                !snapshot.data.first && !snapshot.data.second,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16, bottom: 12),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.grey[800]),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.grey[900]
                                                  .withOpacity(0.7))),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent[700],
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "RESET",
                                        style: TextStyle(
                                            color: Colors.amber[200]
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  onPressed: () => _vm.reset()),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
