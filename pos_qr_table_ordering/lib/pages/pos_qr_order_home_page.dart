import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_qr_table_ordering/widgets/category_widget.dart';
import 'package:pos_qr_table_ordering/widgets/discount_card_widget.dart';
import 'package:pos_qr_table_ordering/widgets/product_card_widget.dart';
import 'package:pos_qr_table_ordering/widgets/product_detail_widget.dart';

class PosQrOrderHomePage extends StatelessWidget {
  const PosQrOrderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          useDefaultSemanticsOrder: true,
          excludeHeaderSemantics: true,
          title: Text(
            "Shop's Menu",
            style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'inter'),
          ),
          centerTitle: true,
          leading: Image.network(
            width: 44,
            height: 44,
            'https://www.shutterstock.com/image-photo/logo-pos-point-sales-260nw-2705439507.jpg',
          ),
          actions: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.black.withValues(alpha: 0.1),
                // border: Border.all(width: 0.5, color: Colors.black87),
              ),
              child: Icon(CupertinoIcons.info_circle),
            ),
            SizedBox(width: 16),
          ],
        ),
        body: ListView(
          children: [
            // search
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: CupertinoSearchTextField(),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 20),
              child: DiscountCardWidget(),
            ),

            // category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: List.generate(10, (index) {
                    return const CategoryWidget();
                  }),
                ),
              ),
            ),
            SizedBox(height: 60),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 70,
                childAspectRatio: 1,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailWidget(),
                        ),
                      );
                    },
                    child: const ProductCardWidget(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
