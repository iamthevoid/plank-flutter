import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plank/plank_state.dart';
import 'package:plank/utils.dart';
import 'package:plank/widgets/duration_box.dart';
import 'package:plank/widgets/optional.dart';
import 'package:plank/widgets/plank_run_button.dart';

import '../plank_bloc.dart';

class PlankPage extends StatefulWidget {
  static final String route = '/';

  @override
  _PlankPageState createState() => _PlankPageState();
}

class _PlankPageState extends State<PlankPage> {
  final TextEditingController _activeController =
      TextEditingController(text: "${PlankBloc.DEFAULT_ACTIVE_PERIOD}");

  final TextEditingController _restController =
      TextEditingController(text: "${PlankBloc.DEFAULT_REST_PERIOD}");

  PlankBloc _bloc;

  @override
  void initState() {
    _bloc = PlankBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
        bloc: _bloc,
        builder: (bloc, state) => Scaffold(
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
                        DurationBox(
                            editable: state is PlankInitialState,
                            controller: _activeController,
                            nonEditableText: !(state is PlankInitialState)
                                ? "Active Period: ${state.activeDurationSeconds()}s"
                                : '',
                            editableHint: 'Active (sec)'),
                        DurationBox(
                            editable: state is PlankInitialState,
                            controller: _restController,
                            nonEditableText: !(state is PlankInitialState)
                                ? "Rest Period: ${state.restDurationSeconds()}s"
                                : '',
                            editableHint: 'Rest (sec)'),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ActionButton(
                      stopped: !(state is PlankCounterState),
                      function: () {
                        _bloc.onButtonPressed(
                            activeSeconds: _activeController.text,
                            restSeconds: _restController.text);
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: RichText(
                                textAlign: TextAlign.center,
                                text: spanned(
                                  state is PlankInitialState
                                      ? ' \n '
                                      : "${(state.isActive() ? "Plank" : "Rest").toUpperCase()}\n${state.currentToString()}",
                                  separator: '\n',
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: (!(state is PlankInitialState) && state.isActive())
                                        ? Colors.amber[200]
                                        : Colors.green[600],
                                  ),
                                ),
                              ))
                  ],
                ),
              ),
              Optional(
                  condition: !(state is PlankInitialState),
                  create: (context) => Positioned(
                        left: 32,
                        bottom: 32,
                        child: RichText(
                          text: spanned(
                            "Plank Summary:\n${state.fullPlankPeriods()} times, ${state.plankSummaryToString()}",
                            separator: ':\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber[200].withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
              Optional(
                  condition: state is PlankStopState,
                  create: (context) => AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        bottom: 20,
                        right: 16,
                        child: RaisedButton(
                            color: Colors.grey[900].withOpacity(0.5),
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
                                      color: Colors.amber[200].withOpacity(0.7),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            onPressed: () => _bloc.reset()),
                      ))
            ],
          ),
        ),
      );
}
