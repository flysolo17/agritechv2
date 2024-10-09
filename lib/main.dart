import 'package:agritechv2/blocs/cart/cart_bloc.dart';
import 'package:agritechv2/blocs/product/product_bloc.dart';
import 'package:agritechv2/firebase_options.dart';
import 'package:agritechv2/repository/audit_repository.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/cart_repository.dart';
import 'package:agritechv2/repository/content_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/repository/favorites_repository.dart';
import 'package:agritechv2/repository/gcash-repository.dart';
import 'package:agritechv2/repository/message_repository.dart';
import 'package:agritechv2/repository/newsletter.dart';
import 'package:agritechv2/repository/pest_repository.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/repository/review_repository.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/views/nav/bot/bot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/messenger/messenger_bloc.dart';
import 'config/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransactionRepostory(),
        ),
        RepositoryProvider(
          create: (context) => PestRepository(),
        ),
        RepositoryProvider(
          create: (context) => FavoritesRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuditRepository(),
        ),
        RepositoryProvider(
          create: (context) => MessagesRepository(),
        ),
        RepositoryProvider(
          create: (context) => NewsletterRepository(),
        ),
        RepositoryProvider(
          create: (context) => ReviewRepository(),
        ),
        RepositoryProvider(
          create: (context) => ContentRepository(),
        ),
        RepositoryProvider(
          create: (context) => GcashRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => MessengerBloc(
                messagesRepository: context.read<MessagesRepository>(),
                myID: context.read<AuthRepository>().currentUser?.uid ?? ''),
          ),
          BlocProvider(
            create: (context) => CartBloc(
                cartRepository: context.read<CartRepository>(),
                uid: context.read<AuthRepository>().currentUser?.uid ?? ''),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme:
                  IconThemeData(color: Colors.white), // Set icon color to white
              titleTextStyle:
                  TextStyle(color: Colors.white), // Set text color to white
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: ColorStyle.brandRed),
            useMaterial3: true,
          ),
          routerConfig: AppRouter().router,
        ),
      ),
    );
  }
}
