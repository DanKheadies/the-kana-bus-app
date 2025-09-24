import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

class LoginModal extends StatefulWidget {
  final BuildContext context;

  const LoginModal({super.key, required this.context});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  bool showPassword = false;
  Logger log = Logger();

  @override
  Widget build(BuildContext context) {
    return CustomMessengerModal(
      context: context,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          bool isWorking = state.status == AuthenticationStatus.submitting;
          return CustomModal(
            context: context,
            isWorking: isWorking,
            message: 'Authenticating this account.',
            onTap: isWorking ? () {} : () => Navigator.of(context).pop(),
            child:
                isWorking
                    ? CircularProgressIndicator()
                    : _handleLoginStatus(state, context),
          );
        },
      ),
    );
  }

  Widget _handleLoginStatus(AuthenticationState state, BuildContext context) {
    if (state.status == AuthenticationStatus.success) {
      Navigator.of(context).pop();
      return SizedBox(
        height: 300,
        child: Center(
          child: IconButton(
            icon: Icon(
              Icons.thumb_up,
              color: Theme.of(context).colorScheme.primary,
              size: 69,
            ),
            onPressed: () {
              context.read<AuthenticationCubit>().reset();
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else if (state.status == AuthenticationStatus.error) {
      log.e('AuthCubit error', error: state.errorMessage);
      return _buildError(state, context);
    } else {
      return _buildLogin(state, context);
    }
  }

  Column _buildError(AuthenticationState state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomBlockHeader(
              text: 'Log In Error',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
            // const Spacer(),
            // IconButton(
            //   icon: Icon(
            //     Icons.close,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            //   onPressed: () => Navigator.of(context).pop(),
            //   onLongPress: () {
            //     context.read<AuthenticationCubit>().reset();
            //   },
            // ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          state.errorMessage ?? 'There was an error.',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        const SizedBox(height: 20),
        Text(
          'Please try again or contact support.',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        const SizedBox(height: 25),
        Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationCubit>().reset();
            },
            child: Text('Try Again'),
          ),
        ),
      ],
    );
  }

  Widget _buildLogin(AuthenticationState state, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomBlockHeader(
                text: 'Log In',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const Spacer(),
              // IconButton(
              //   icon: Icon(
              //     Icons.close,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onPressed: () => Navigator.of(context).pop(),
              //   onLongPress: () {
              //     context.read<AuthenticationCubit>().reset();
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              CustomInput(
                labelText: 'Email',
                onChanged:
                    (value) =>
                        context.read<AuthenticationCubit>().emailChanged(value),
                onEnter: (value) {
                  context.read<AuthenticationCubit>().emailChanged(value);
                  _signIn(state, context);
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth < 530 ? screenWidth - 165 : 365,
                    child: CustomInput(
                      labelText: 'Password',
                      obscureText: !showPassword,
                      onChanged: (value) {
                        context.read<AuthenticationCubit>().passwordChanged(
                          value,
                        );
                      },
                      onEnter: (value) {
                        context.read<AuthenticationCubit>().passwordChanged(
                          value,
                        );
                        _signIn(state, context);
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(() {
                            showPassword = !showPassword;
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              // TODO: consider an animated transition between the modals rather
              // than an entirely new modal
              String currentEmail = state.email;
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return PasswordResetModal(currentEmail: currentEmail);
                },
              );
            },
            child: Text('Forgot Password?'),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed:
                EmailValidator.validate(state.email) && state.password != ''
                    ? () {
                      context.read<AuthenticationCubit>().login();
                    }
                    : null,
            child: Text('Login'),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed:
                EmailValidator.validate(state.email) && state.password != ''
                    ? () {
                      context.read<AuthenticationCubit>().register();
                    }
                    : null,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

  void _signIn(AuthenticationState state, BuildContext context) {
    if (EmailValidator.validate(state.email) && state.password != '') {
      context.read<AuthenticationCubit>().login();
    }
  }
}
