// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/cart_screen.dart';
import 'package:provider_shopper/catalog_screen.dart';

Widget createCatalogScreen() => MultiProvider(
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
      child: const MaterialApp(
        home: catalog(),
      ),
    );

void main() {
  final catalogListItems = catalogmodel.items.sublist(0, 3);

  group('CatalogScreen Widget Tests', () {
    testWidgets('Testing item row counts and text', (tester) async {
      await tester.pumpWidget(createCatalogScreen());

      // Testing for the items on the screen after modifying
      // the model for a fixed number of items.
      for (var item in catalogListItems) {
        expect(find.text(item), findsWidgets);
      }
    });

    testWidgets('Testing the ADD buttons and check after clicking',
        (tester) async {
      await tester.pumpWidget(createCatalogScreen());

      // Should find ADD buttons on the screen.
      expect(find.text('ADD'), findsWidgets);

      // Performing the click on the ADD button of the first item in the list.
      await tester.tap(find.widgetWithText(TextButton, 'ADD').first);
      await tester.pumpAndSettle();

      // Verifying if the tapped ADD button has changed to the check icon.
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
