import 'package:equatable/equatable.dart';
import 'package:flutter_fashion/app/blocs/auth/auth_event.dart';
import 'package:flutter_fashion/app/presentation/login/export.dart';
import 'package:flutter_fashion/app/repositories/auth_repository.dart';
import 'package:flutter_fashion/core/base/exception/exception.dart';
import 'package:flutter_fashion/core/base/params/register.dart';
import 'package:flutter_fashion/core/firebase/firebase_service.dart';
import 'package:flutter_fashion/core/status_cubit/status_cubit.dart';
import 'package:flutter_fashion/core/storage/key.dart';
import 'package:flutter_fashion/utils/alert/error.dart';
import 'package:flutter_fashion/utils/alert/loading.dart';
import 'package:flutter_fashion/utils/alert/success.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with FirebaseMixin {
  final AuthRepositoryImpl _authRepositoryImpl;
  AuthCubit({required AuthRepositoryImpl auth})
      : _authRepositoryImpl = auth,
        super(const AuthState());

  void call(AuthEvent event,
      {Map<String, dynamic>? param, BuildContext? context}) {
    switch (event) {
      case AuthEvent.changedPhone:
        if (param != null) _onChangedPhone(param);
        break;
      case AuthEvent.changedPassword:
        if (param != null) _onChangedPassword(param);
        break;
      case AuthEvent.submitLogin:
        if (context != null) _onSubmitLogin(context);
        break;
      case AuthEvent.loggout:
        if (context != null) _onSubmitLoggout(context);
        break;
      default:
    }
  }

  void _onChangedPhone(Map<String, dynamic>? param) {
    if (param != null) {
      if (param["phoneNumber"] != null) {
        emit(state.copyWith(
            phoneNumber: param["phoneNumber"], status: AppStatus.init));
      }
    } else {
      throw ParamRequestException();
    }
  }

  void _onChangedPassword(Map<String, dynamic>? param) {
    if (param != null) {
      if (param["password"] != null) {
        emit(state.copyWith(
            password: param["password"], status: AppStatus.init));
      }
    } else {
      throw ParamRequestException();
    }
  }

  void _onSubmitLogin(BuildContext context) async {
    emit(state.copyWith(status: AppStatus.loading));
    loadingAlert(context: context);

    final String phone = state.phoneNumber;
    final String password = state.password;

    final result = await _authRepositoryImpl.login(phone, password);
    AppRoutes.router.pop();

    result.fold(
      (error) {
        emit(state.copyWith(status: AppStatus.error));
        errorAlert(context: context, message: error);
      },
      (dataReposonse) {
        if (dataReposonse.status) {
          AppRoutes.router.go(Routes.HOME);
          emit(state.copyWith(status: AppStatus.success));
        }
      },
    );
  }

  void _onSubmitLoggout(BuildContext context) async {
    final result = await _authRepositoryImpl.loggout();

    result.fold(
      (error) {
        emit(state.copyWith(status: AppStatus.error));
        errorAlert(context: context, message: error);
      },
      (dataReposonse) {
        if (dataReposonse.status) {
          AppRoutes.router.go(Routes.LOGIN);
          HydratedBloc.storage.delete(KeyStorage.token);
          emit(const AuthState());
        }
      },
    );
  }

  void accountRegister(RegisterParams param, BuildContext context) async {
    emit(state.copyWith(status: AppStatus.loading));
    loadingAlert(context: context);

    final result = await _authRepositoryImpl.register(param);

    AppRoutes.router.pop();
    result.fold(
      (error) {
        emit(state.copyWith(status: AppStatus.error));
        errorAlert(context: context, message: error);
      },
      (dataReposonse) async {
        if (dataReposonse.message == "Email or phone are already exists") {
          emit(state.copyWith(status: AppStatus.error));
          errorAlert(context: context, message: dataReposonse.message);
        } else {
          await successAlert(context: context, message: dataReposonse.message);
          AppRoutes.router.go(Routes.LOGIN);
          emit(const AuthState());
        }
      },
    );
  }

  void authGoogle(BuildContext context) async {
    loadingAlert(context: context);
    final result = await signInWithGoogle();

    result.fold(
      (error) {
        //remove poup loading
        AppRoutes.router.pop();
        if (error.isNotEmpty) {
          errorAlert(context: context, message: error);
          emit(state.copyWith(status: AppStatus.error));
        }
      },
      (data) async {
        emit(state.copyWith(status: AppStatus.loading));

        _logoutGoogle();
        final resultSecond = await _authRepositoryImpl.loginGoogle(
            data.user!.displayName!, data.user!.email!);
        //remove poup loading
        AppRoutes.router.pop();

        resultSecond.fold((error) {
          errorAlert(context: context, message: error);
          emit(state.copyWith(status: AppStatus.error));
        }, (dataReponse) {
          AppRoutes.router.go(Routes.HOME);
          emit(const AuthState());
        });
      },
    );
  }

  void _logoutGoogle() async {
    await signOut();
  }

  @override
  String toString() {
    super.toString();
    return "state: $state";
  }
}
