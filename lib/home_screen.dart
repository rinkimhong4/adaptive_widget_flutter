import 'package:adaptive_widgeet/adaptive_ui_custom/adapetive_icon.dart';
import 'package:adaptive_widgeet/adaptive_ui_custom/adapetive_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCheck = false;

  Future<void> _deleteReceipt(BuildContext context) async {
    final confirmed = await context.showAdaptiveConfirm(
      title: 'Delete receipt?',
      message: 'This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    // proceed with deletion...
    await context.showAdaptiveAlert(
      title: 'Deleted',
      message: 'Receipt was removed successfully.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Receipts',
      showBack: false,
      actions: [
        AdaptiveAction(
          materialIcon: Icons.calendar_today_outlined,
          cupertinoIcon: CupertinoIcons.calendar,
          onTap: () {},
        ),
      ],
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            AdaptiveTextField(
              prefix: AdaptiveIcons.calendar(() {}),
              suffix: Icon(Icons.close),
            ),
            Row(
              children: [
                AdaptiveSwitch(
                  value: _isCheck,
                  onChanged: (bool value) {
                    setState(() {
                      _isCheck = value;
                    });
                  },
                ),

                //
                AdaptiveLoading(size: 30),
              ],
            ),
            // btn
            AdaptiveButton(
              style: AdaptiveButtonStyle.destructive,
              color: Colors.amber,

              onPressed: () => _deleteReceipt(context),
              child: Text("data"),
            ),
            AdaptiveButton(
              style: AdaptiveButtonStyle.filled,
              color: Colors.amber,
              onPressed: () async {
                await context.showAdaptiveAlert(
                  title: 'Saved',
                  message: 'Your changes have been saved.',
                );
              },
              child: Text("data"),
            ),
            // Dialog
            ElevatedButton(
              onPressed: () {
                AdaptiveDialog.alert(
                  context,
                  title: 'Success',
                  message: 'Your order was placed successfully!',
                );
              },
              child: Text('Show Alert'),
            ),

            ElevatedButton(
              onPressed: () {
                AdaptiveActionSheet.show(
                  context,
                  title: 'Share via',
                  actions: [
                    AdaptiveSheetAction(label: 'Telegram', onTap: () {}),
                    AdaptiveSheetAction(label: 'Print', onTap: () {}),
                    AdaptiveSheetAction(
                      label: 'Delete',
                      onTap: () {},
                      isDestructive: true,
                    ),
                  ],
                );
              },
              child: Text('Show Alert'),
            ),
          ],
        ),
      ),
    );
  }
}
