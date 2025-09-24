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
      endDrawer: CustomDrawer(),
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
                BusmPane(
                  controller: inputCont,
                  label: 'Input',
                  onChanged: (value) async {
                    // TODO: handle translating if the user saves before trans
                    // can complete
                    if (value != '') {
                      await _translate(value);
                    } else {
                      _clear();
                    }
                  },
                  onEditingComplete: () {
                    _save();
                    _closeKeyboard();
                    _clear();
                  },
                  onSubmitted: (_) {},
                  textColor: Theme.of(context).colorScheme.surface,
                  focusInput: focusInput,
                  isDisabled: false,
                ),
                const SizedBox(height: 8, width: double.infinity),
                BusmPane(
                  controller: englishCont,
                  label: 'English Translation',
                  onChanged: (_) {},
                  onEditingComplete: () {},
                  onSubmitted: (_) {},
                  textColor: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 8, width: double.infinity),
                BusmPane(
                  controller: kanaCont,
                  label: 'Kana Translation',
                  onChanged: (_) {},
                  onEditingComplete: () {},
                  onSubmitted: (_) {},
                  textColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8, width: double.infinity),
                BusmPane(
                  controller: romajiCont,
                  label: 'Romaji Translation',
                  onChanged: (_) {},
                  onEditingComplete: () {},
                  onSubmitted: (_) {},
                  textColor: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 20),
                // TODO: refactor as widget
                BlocBuilder<BusmCubit, BusmState>(
                  builder: (context, state) {
                    return Expanded(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.kanaBusms.length,
                        itemBuilder: (context, index) {
                          // TODO: copy the input; swipe left immediate
                          // TODO: delete the busm; swipe right w/ confirmation
                          return Slidable(
                            key: Key(
                              state.kanaBusms[index].createdAt.toString(),
                            ),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    String input = state.kanaBusms[index].input;
                                    // setState(() {
                                    //   kanaBusms.removeAt(index);
                                    // });
                                    context.read<BusmCubit>().removeBusm(index);
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '$input has been removed.',
                                          ),
                                        ),
                                      );
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  // Note: should share all 4 inputs (w/ labels)
                                  onPressed: (context) => print('TODO: share'),
                                  backgroundColor: Color(0xFF21B7CA),
                                  foregroundColor: Colors.white,
                                  icon: Icons.share,
                                  label: 'Share',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 2,
                                  onPressed: (context) {
                                    String input = state.kanaBusms[index].input;
                                    setState(() {
                                      inputCont.text = input;
                                    });
                                    _translate(input);
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '$input has been copied.',
                                          ),
                                        ),
                                      );
                                  },
                                  backgroundColor: Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.copy,
                                  label: 'Copy',
                                ),
                                // SlidableAction(
                                //   onPressed: (context) => print('TODO: save'),
                                //   backgroundColor: Color(0xFF0392CF),
                                //   foregroundColor: Colors.white,
                                //   icon: Icons.save,
                                //   label: 'Save',
                                // ),
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
                                      state.kanaBusms[index].input,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surfaceBright,
                                      ),
                                    ),
                                    Text(
                                      state.kanaBusms[index].english,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                      ),
                                    ),
                                    Text(
                                      state.kanaBusms[index].kana,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      state.kanaBusms[index].romaji,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                    index != state.kanaBusms.length - 1
                                        ? Divider(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                        )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
      Busm newBusm = Busm(
        createdAt: DateTime.now(),
        english: englishCont.text,
        input: inputCont.text,
        kana: kanaCont.text,
        romaji: romajiCont.text,
      );

      context.read<BusmCubit>().addBusm(newBusm);
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
