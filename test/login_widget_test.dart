// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/cart_screen.dart';
import 'package:provider_shopper/catalog_screen.dart';
import 'package:provider_shopper/main.dart';

void main() {
  testWidgets('Login page Widget test', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider(create: (context) => catalogmodel()),
        ChangeNotifierProxyProvider<catalogmodel, cartmodel>(
          create: (context) => cartmodel(),
          update: (context, catalog, cart) {
            cart!.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(routerConfig: router()),
    ));

    // Verifying the behaviour of ENTER button.
    await tester.tap(find.text('ENTER'));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsOneWidget);
  });
}
