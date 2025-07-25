import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/app_assets.dart';
import '../../../data/repositories/images_repository_impl.dart';
import '../../../domain/usecases/select_image_usecase.dart';
import '../../blocs/select_images/select_images_cubit.dart';
import '../../blocs/select_images/select_images_state.dart';

class SelectImagesScreen extends StatelessWidget {
  const SelectImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SelectImagesCubit(SelectImageUsecase(ImagesRepositoryImpl())),
      child: BlocBuilder<SelectImagesCubit, SelectImagesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: const Center(
                child: Text(
                  "Convert Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),

                backgroundColor: AppColors.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
              onPressed: () {
                context.read<SelectImagesCubit>().onShowSnackBar(context);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: AppColors.font, size: 30),
                  SizedBox(width: 16),
                  Text(
                    "Select Images",
                    style: TextStyle(fontSize: 16, color: AppColors.font),
                  ),
                ],
              ),
            ),

            body: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "convert_images");
              },
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.selectImage,
                        width: 170,
                        height: 170,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Select images",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.fontGray,
                        ),
                      ),
                      const Text(
                        "or share them with the app",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.fontGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
