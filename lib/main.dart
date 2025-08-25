import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus_app/barrel.dart';
import 'package:kana_bus_app/firebase_options.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  Logger.level = Level.all;

  SystemChannels.textInput.invokeMethod('TextInput.hide');

  runApp(const KanaBus());
}

class KanaBus extends StatelessWidget {
  const KanaBus({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BrightnessCubit()),
        BlocProvider(create: (context) => BusmCubit()),
      ],
      child: BlocBuilder<BrightnessCubit, Brightness>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
            theme: state == Brightness.dark ? darkTheme() : lightTheme(),
          );
        },
      ),
    );
  }
}
