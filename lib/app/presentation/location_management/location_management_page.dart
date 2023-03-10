// ignore_for_file: use_build_context_synchronously

import 'package:flutter_fashion/app/blocs/address_user/address_user_cubit.dart';
import 'package:flutter_fashion/app/presentation/create_address/create_address_page.dart';
import 'package:flutter_fashion/common/components/app/background_app.dart';
import 'package:flutter_fashion/app/presentation/location_management/components/item_location_user.dart';
import 'package:flutter_fashion/core/models/address.dart';
import 'package:flutter_fashion/export.dart';
import 'package:flutter_fashion/routes/export.dart';

class LocationManagementPage extends StatefulWidget {
  const LocationManagementPage({Key? key}) : super(key: key);

  @override
  State<LocationManagementPage> createState() => _LocationManagementPageState();
}

class _LocationManagementPageState extends State<LocationManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressUserCubit>(),
      child: AppBackgroundBlur.normal(
        title: "Quản lý địa chỉ",
        floatingActionButton: Builder(builder: (context) {
          return InkWell(
            onTap: () async {
              final result = await Navigator.of(context).push<ItemAddress?>(
                MaterialPageRoute(
                  builder: (context) => const CreateAddressPage(),
                ),
              );
              context.read<AddressUserCubit>().createNew(result!);
            },
            borderRadius: const BorderRadius.all(Radius.circular(radiusBtn)),
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 65,
              height: 65,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset("assets/icons/profile/float_btn.svg"),
                  const Align(child: Icon(Icons.add_card, color: lightColor)),
                ],
              ),
            ),
          );
        }),
        child: BlocBuilder<AddressUserCubit, AddressUserState>(
          builder: (context, state) {
            if (state.storageList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding - 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Hiện tại bạn chưa cập nhật địa chỉ'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
              itemCount: state.storageList.length,
              itemBuilder: (context, index) {
                final item = state.storageList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ItemLocationUser(
                    key: ValueKey(index),
                    item: item,
                    onDelete: () {
                      context.read<AddressUserCubit>().delete(item);
                      //turn off modal action
                      AppRoutes.pop();
                    },
                    onUseDefault: () {
                      context.read<AddressUserCubit>().setUseDefault(item);
                      //turn off modal action
                      AppRoutes.pop();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}