import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:translator/translator.dart';

class KanaBusScreen extends StatefulWidget {
  const KanaBusScreen({super.key});

  @override
  State<KanaBusScreen> createState() => _KanaBusScreenState();
}

class _KanaBusScreenState extends State<KanaBusScreen> {
  bool isLoading = false;
  FocusNode focusInput = FocusNode();
  GoogleTranslator translator = GoogleTranslator();
  KanaKit kanaKit = KanaKit();
  List<Busm> kanaBusms = [];
  TextEditingController englishCont = TextEditingController();
  TextEditingController inputCont = TextEditingController();
  TextEditingController kanaCont = TextEditingController();
  TextEditingController romajiCont = TextEditingController();

  @override
  void dispose() {
    englishCont.dispose();
    inputCont.dispose();
    kanaCont.dispose();
    romajiCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      floatingActionButton: InputButton(onTap: () => focusInput.requestFocus()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<BusmCubit, BusmState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: inputCont,
                  onChanged: (value) {
                    if (value != '') {
                      _translate(value);
                    } else {
                      // print('clear');
                      _clear();
                    }
                  },
                  onEditingComplete: () {
                    _save();
                    _closeKeyboard();
                    _clear();
                  },
                  onSubmitted: (_) {},
                  focusNode: focusInput,
                  decoration: InputDecoration(
                    labelText: 'Input',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 8, width: double.infinity),
                TextField(
                  controller: englishCont,
                  readOnly: true,
                  onChanged: (_) {},
                  onSubmitted: (_) {},
                  decoration: InputDecoration(
                    labelText: 'English Translation',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 8, width: double.infinity),
                TextField(
                  controller: kanaCont,
                  readOnly: true,
                  onChanged: (_) {},
                  onSubmitted: (_) {},
                  decoration: InputDecoration(
                    labelText: 'Kana Translation',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8, width: double.infinity),
                TextField(
                  controller: romajiCont,
                  readOnly: true,
                  onChanged: (_) {},
                  onSubmitted: (_) {},
                  decoration: InputDecoration(
                    labelText: 'Romaji Translation',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: kanaBusms.length,
                    itemBuilder: (context, index) {
                      // TODO: copy the input; swipe left immediate
                      // TODO: delete the busm; swipe right w/ confirmation
                      return Slidable(
                        key: Key(kanaBusms[index].createdAt.toString()),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) => print('delete'),
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) => print('share'),
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),
                          ],
                        ),

                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) => print('archive'),
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Archive',
                            ),
                            SlidableAction(
                              onPressed: (context) => print('save'),
                              backgroundColor: Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.save,
                              label: 'Save',
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kanaBusms[index].input,
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceBright,
                                  ),
                                ),
                                Text(
                                  kanaBusms[index].english,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                Text(
                                  kanaBusms[index].kana,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  kanaBusms[index].romaji,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                index != kanaBusms.length - 1
                                    ? Divider(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                      return Dismissible(
                        key: Key(kanaBusms[index].createdAt.toString()),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            String input = kanaBusms[index].input;
                            setState(() {
                              kanaBusms.removeAt(index);
                            });
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text('$input has been removed.'),
                                ),
                              );
                          } else if (direction == DismissDirection.endToStart) {
                            // TODO copy
                            setState(() {
                              inputCont.text = kanaBusms[index].input;
                            });
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(content: Text('Trying to copy..')),
                              );
                          }
                        },
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return Future.value(false);
                          }
                          return Future.value(true);
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15),
                          color: Theme.of(context).colorScheme.error,
                          child: Icon(
                            Icons.delete,
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 15),
                          color: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.copy,
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kanaBusms[index].input,
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceBright,
                                ),
                              ),
                              // isLoading
                              //     ? Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //         vertical: 10,
                              //       ),
                              //       child: LinearProgressIndicator(),
                              //     )
                              //     : Text(
                              //       kanaBusms[index].english,
                              //       style: TextStyle(
                              //         color:
                              //             Theme.of(context).colorScheme.tertiary,
                              //       ),
                              //     ),
                              Text(
                                kanaBusms[index].english,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              Text(
                                kanaBusms[index].kana,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                kanaBusms[index].romaji,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              index != kanaBusms.length - 1
                                  ? Divider(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _clear() {
    inputCont.clear();
    englishCont.clear();
    kanaCont.clear();
    romajiCont.clear();
  }

  void _closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _save() {
    if (inputCont.text.isNotEmpty) {
      setState(() {
        kanaBusms.add(
          Busm(
            createdAt: DateTime.now(),
            english: englishCont.text,
            input: inputCont.text,
            kana: kanaCont.text,
            romaji: romajiCont.text,
          ),
        );
        kanaBusms.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      });
    }
  }

  Future<void> _translate(String input) async {
    if (input != '') {
      setState(() {
        kanaCont.text = kanaKit.toKana(input);
        romajiCont.text = kanaKit.toRomaji(input);
        isLoading = true;
      });

      // await Future.delayed(Duration(seconds: 3));
      var translation = await translator.translate(
        kanaCont.text,
        from: 'auto',
        to: 'en',
      );

      // print(translation);
      if (input != '' && inputCont.text != '') {
        setState(() {
          englishCont.text = translation.text;
          isLoading = false;
        });
      }
    }
  }
}
