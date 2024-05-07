
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class GridListViewProducts extends StatefulWidget {
  const GridListViewProducts({
    super.key,
    this.productList,
    this.isList = false,
  });

  final List<ProductModel>? productList;
  final bool? isList;

  @override
  State<GridListViewProducts> createState() => _GridListViewProductsState();
}

class _GridListViewProductsState extends State<GridListViewProducts> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.isList == true ? _buildListView() : _buildGridView(),
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio:
            AppDimensions.screenWidth / AppDimensions.screenHeight * 1.25,
      ),
      itemCount: widget.productList!.take(4).length,
      itemBuilder: (BuildContext context, int index) {
        final product = widget.productList![index];
        return _buildProductContainer(product, index, context);
      },
    );
  }

  Obx _buildProductContainer(
    ProductModel product,
    int index,
    BuildContext context,
  ) {
    return Obx(() {
      return InkWell(
        onTap: () {
          Get.toNamed(Routes.productDetailView);
        },
        child: Container(
          height: AppDimensions.screenHeight * 0.34,
          width: AppDimensions.screenWidth * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryExtraLight,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        product.image ?? AppAssets.bgImageIcon,
                        fit: BoxFit.fill,
                        scale: 4.2,
                        height: AppDimensions.screenHeight * 0.18,
                        width: AppDimensions.screenWidth * 0.45,
                      ),
                    ),
                  ),
                  // Image
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        final bool isFavorite = product.isFav?.value ?? false;
                        product.isFav?.value = !isFavorite;
                      },
                      child: widget.productList![index].isFav!.value == false
                          ? Image.asset(
                              AppAssets.favoriteEmpty,
                              scale: 3.5,
                            )
                          : Image.asset(
                              AppAssets.favoriteFilled,
                              scale: 3.5,
                            ),
                    ),
                  ),
                  height4SizedBox,
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                    ),
                    height2SizedBox,
                    Text(
                      product.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    height2SizedBox,
                    Text(
                      "From \$${product.price}",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    height2SizedBox,
                    _colorBar(product.colors),
                    height4SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Ratings

                        Row(
                          children: [
                            RatingBar(
                              initialRating: 3.2,
                              allowHalfRating: true,
                              ratingWidget: RatingWidget(
                                full: Image.asset(
                                  AppAssets.ratingFull,
                                ),
                                half: Image.asset(
                                  AppAssets.ratingHalf,
                                ),
                                empty: Image.asset(
                                  AppAssets.ratingHalf,
                                ),
                              ),
                              itemSize: 14.0,
                              onRatingUpdate: print,
                            ),
                            Text(
                              "(${product.price}K)",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 10,
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primary,
                          ),
                          child: Image.asset(
                            AppAssets.cartIcon,
                            scale: 3.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ListView _buildListView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => width10SizedBox,
      shrinkWrap: true,
      itemCount: widget.productList!.length,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final product = widget.productList![index];
        return _buildProductContainer(product, index, context);
      },
    );
  }

  //Categories Items Horizontal List
  Widget _colorBar(List<String>? model) {
    return SizedBox(
      height: 20,
      width: AppDimensions.screenWidth,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return width6SizedBox;
        },
        itemCount: model?.length ?? 0,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          final colorCode = "0xff${model?[i]}";
          return Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Color(int.parse(colorCode)),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }
}
