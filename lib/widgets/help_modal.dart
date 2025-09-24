import 'package:cloud_functions/cloud_functions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

class HelpModal extends StatefulWidget {
  final BuildContext context;

  const HelpModal({super.key, required this.context});

  @override
  State<HelpModal> createState() => _HelpModalState();

  // static Future<void> openHelpModal(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => HelpModal(context: context),
  //   );
  // }
}

class _HelpModalState extends State<HelpModal> {
  bool canSend = false;
  bool clearInput = false;
  bool isSending = false;
  Logger log = Logger();
  String email = '';
  String message = '';

  @override
  void initState() {
    super.initState();
    if (context.read<UserBloc>().state.user.email != '') {
      setState(() {
        email = context.read<UserBloc>().state.user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: convert to CustomMessengerModal, et al for scaffold message
    // const double outerPadding = 25;
    return CustomMessengerModal(
      context: context,
      child: CustomModal(
        context: context,
        isWorking: isSending,
        onTap: isSending ? () {} : () => Navigator.of(context).pop(),
        child:
            isSending
                ? CircularProgressIndicator()
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('Test.')));
                      },
                      child: Text(
                        'Contact Support',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // child: Flexible(
                      //   flex: 3,
                      //   child: Text(
                      //     'Contact Support',
                      //     style: Theme.of(
                      //       context,
                      //     ).textTheme.headlineSmall!.copyWith(
                      //       color: Theme.of(context).colorScheme.surface,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: CustomInput(
                        clearText: clearInput,
                        initialValue: email,
                        isMulti: false,
                        labelText: 'Email',
                        onChanged: (value) {
                          if (value != '' && message != '') {
                            setState(() {
                              canSend = true;
                              email = value;
                            });
                          } else {
                            setState(() {
                              canSend = false;
                              email = value;
                            });
                          }
                        },
                        onEnter: (_) {},
                      ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: CustomInput(
                        clearText: clearInput,
                        isMulti: true,
                        labelText: 'Message',
                        onChanged: (value) {
                          if (value != '' && email != '') {
                            setState(() {
                              canSend = true;
                              message = value;
                            });
                          } else {
                            setState(() {
                              canSend = false;
                              message = value;
                            });
                          }
                        },
                        onEnter: (_) {},
                      ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child:
                          isSending
                              ? CircularProgressIndicator()
                              : TextButton(
                                onPressed:
                                    canSend
                                        ? () async {
                                          // print('submit');
                                          await _submit(context);
                                        }
                                        : null,
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                    color:
                                        canSend
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
      ),
      // child: Dialog(
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   child: Padding(
      //     padding: const EdgeInsets.only(
      //       left: outerPadding,
      //       right: outerPadding,
      //       top: outerPadding,
      //       bottom: outerPadding / 2,
      //     ),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Flexible(
      //           flex: 3,
      //           child: Text(
      //             'Contact Support',
      //             style: Theme.of(context).textTheme.headlineSmall!.copyWith(
      //               color: Theme.of(context).colorScheme.surface,
      //               fontWeight: FontWeight.w700,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //         const Spacer(flex: 1),
      //         Flexible(
      //           flex: 5,
      //           child: CustomInput(
      //             clearText: clearInput,
      //             initialValue: email,
      //             isMulti: false,
      //             labelText: 'Email',
      //             onChanged: (value) {
      //               if (value != '' && message != '') {
      //                 setState(() {
      //                   canSend = true;
      //                   email = value;
      //                 });
      //               } else {
      //                 setState(() {
      //                   canSend = false;
      //                   email = value;
      //                 });
      //               }
      //             },
      //             onEnter: (_) {},
      //           ),
      //         ),
      //         const Spacer(flex: 1),
      //         Flexible(
      //           flex: 5,
      //           child: CustomInput(
      //             clearText: clearInput,
      //             isMulti: true,
      //             labelText: 'Message',
      //             onChanged: (value) {
      //               if (value != '' && email != '') {
      //                 setState(() {
      //                   canSend = true;
      //                   message = value;
      //                 });
      //               } else {
      //                 setState(() {
      //                   canSend = false;
      //                   message = value;
      //                 });
      //               }
      //             },
      //             onEnter: (_) {},
      //           ),
      //         ),
      //         const Spacer(flex: 1),
      //         Flexible(
      //           flex: 5,
      //           child:
      //               isSending
      //                   ? CircularProgressIndicator()
      //                   : TextButton(
      //                     onPressed:
      //                         canSend
      //                             ? () async {
      //                               // print('submit');
      //                               await _submit(context);
      //                             }
      //                             : null,
      //                     child: Text(
      //                       'Send',
      //                       style: TextStyle(
      //                         color:
      //                             canSend
      //                                 ? Theme.of(context).colorScheme.primary
      //                                 : Theme.of(context).colorScheme.surface,
      //                         fontSize: 18,
      //                       ),
      //                     ),
      //                   ),
      //         ),
      //         const Spacer(flex: 1),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    setState(() {
      isSending = true;
    });

    if (EmailValidator.validate(email)) {
      try {
        await FirebaseFunctions.instance.httpsCallable('helpMessage').call({
          'email': email,
          'message': message,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Your email has been sent.',
                  // 'This function is in development.',
                ),
              ),
            );
        }

        _clearInputs();
      } on FirebaseFunctionsException catch (error) {
        log.e('contact (ff) error', error: error);
      } catch (err) {
        // print('err: $err');
        log.e('contact error', error: err);
      }
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Enter a valid email.')));
    }

    setState(() {
      isSending = false;
    });
  }

  void _clearInputs() async {
    setState(() {
      clearInput = true;
      canSend = false;
      email = '';
      message = '';
    });

    await Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        clearInput = false;
      });
    });
  }
}
