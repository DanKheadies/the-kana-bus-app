import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

class PasswordResetModal extends StatefulWidget {
  final String currentEmail;

  const PasswordResetModal({super.key, this.currentEmail = ''});

  @override
  State<PasswordResetModal> createState() => _PasswordResetModalState();
}

class _PasswordResetModalState extends State<PasswordResetModal> {
  Logger log = Logger();
  TextEditingController emailCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailCont.text = widget.currentEmail;
    context.read<AuthenticationCubit>().emailChanged(widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return CustomMessengerModal(
      context: context,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          bool isWorking = state.status == AuthenticationStatus.resetting;

          return CustomModal(
            context: context,
            isWorking: isWorking,
            onTap: isWorking ? () {} : () => Navigator.of(context).pop(),
            child:
                isWorking
                    ? CircularProgressIndicator()
                    : _handleResetStatus(state, context),
          );
        },
      ),
    );
  }

  Widget _handleResetStatus(AuthenticationState state, BuildContext context) {
    if (state.status == AuthenticationStatus.reset) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomBlockHeader(
                text: 'Reset Sent',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const Spacer(),
              // IconButton(
              //   onPressed: () => Navigator.of(context).pop(),
              //   icon: Icon(
              //     Icons.close,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'An email is being sent to:',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              context.read<AuthenticationCubit>().state.email,
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'If there is an account tied to this email, click the link in the email to reset your password. If you don\'t receive an email, check your spam folders or reach out to support.',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ),
        ],
      );
    }
    if (state.status == AuthenticationStatus.error) {
      log.e('AuthCubit error', error: state.errorMessage);
      return _buildError(state, context);
    } else {
      return _buildReset(state, context);
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
              text: 'Reset Error',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
            // const Spacer(),
            // IconButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   icon: Icon(
            //     Icons.close,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 10),
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

  Column _buildReset(AuthenticationState state, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomBlockHeader(
              text: 'Password Reset',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
            // const Spacer(),
            // IconButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   icon: Icon(
            //     Icons.close,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Please enter your email. A password reset link will be emailed to you.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface.withAlpha(200),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(
          labelText: 'Email',
          cont: emailCont,
          onChanged:
              (value) =>
                  context.read<AuthenticationCubit>().emailChanged(value),
          onEnter: (value) {
            context.read<AuthenticationCubit>().emailChanged(value);
            if (EmailValidator.validate(state.email)) {
              context.read<AuthenticationCubit>().resetPassword();
            }
          },
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: Text('Cancel'),
            // ),
            // const SizedBox(width: 10),
            ElevatedButton(
              onPressed:
                  EmailValidator.validate(state.email)
                      ? () {
                        context.read<AuthenticationCubit>().resetPassword();
                      }
                      : null,
              child: Text('Reset'),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}
