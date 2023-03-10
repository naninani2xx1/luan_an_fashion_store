import 'package:flutter_fashion/app/models/product/product.dart';
import 'package:flutter_fashion/core/base/api/api.dart';
import 'package:flutter_fashion/utils/extensions/double.dart';
import 'package:flutter_fashion/utils/extensions/int.dart';

import '../../export.dart';

class ItemProduct extends StatelessWidget {
  const ItemProduct({
    super.key,
    required this.product,
  });
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: CachedNetworkImage(
              imageUrl: ApiService.imageUrl + product.product_detail[0].photo,
              fit: BoxFit.fitWidth,
              httpHeaders: getIt<ApiService>().headers,
              placeholder: (context, url) {
                return ColoredBox(
                  color: skeletonColor,
                  child: const SizedBox(),
                );
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  product.name,
                  style: PrimaryFont.instance
                      .copyWith(fontSize: 14.0, height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.regular_price.toDouble().toVndCurrency(),
                      style: PrimaryFont.instance.copyWith(
                        fontSize: 12.0,
                        color: const Color(0xFFFF7262),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    product.sale_price != null
                        ? ColoredBox(
                            color: errorColor.withOpacity(0.2),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: Text(
                                "-${product.sale_price!.toDouble().toVndCurrency()}",
                                style: PrimaryFont.instance.copyWith(
                                  fontSize: 7.0,
                                  color: errorColor,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '???? b??n: ${product.sold.formatNumber()}',
                    style: PrimaryFont.instance.copyWith(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/shipping_delivery.svg",
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ItemProductSkeleton extends StatelessWidget {
  const ItemProductSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ColoredBox(
                color: skeletonColor,
                child: const SizedBox(),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ColoredBox(
                    color: skeletonColor,
                    child: const SizedBox(),
                  ),
                ),
                const SizedBox(height: 5.0),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ColoredBox(
                    color: skeletonColor,
                    child: const SizedBox(),
                  ),
                ),
                const SizedBox(height: 5.0),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ColoredBox(
                    color: skeletonColor,
                    child: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
