import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawker/domain/entities/oauth_user_info.dart';
import 'package:pawker/domain/entities/user.dart';

import 'package:pawker/ui/features/auth/view_model/auth_view_model.dart';
import 'package:pawker/ui/features/auth/widgets/login_screen.dart';
import 'package:pawker/ui/features/owner_main_screen/widgets/owner_main_screen.dart';
import 'package:pawker/ui/features/walker_main_screen/walker_main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pawker/core/utils/app_logger.dart';
import 'package:pawker/ui/core/components/app_text_field.dart';
import 'package:pawker/ui/core/themes/theme.dart';
import 'package:pawker/ui/core/utils/user_friendly_error.dart';
import 'package:pawker/di/repository_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const path = '/auth/signup';
  final OAuthUserInfo oauthUserInfo;

  const SignupScreen({super.key, required this.oauthUserInfo});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  static const int _totalSteps = 3;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.owner;

  /// 현재 단계 (0: 역할, 1: 기본정보, 2: 정책동의)
  int _currentStep = 0;

  /// progress 애니메이션용: 직전 단계 (연결선 보간에 사용)
  int _previousStep = 0;

  // 정책 동의 상태
  bool _allAgreed = false;
  bool _privacyPolicyAgreed = false;
  bool _termsOfServiceAgreed = false;
  bool _dataCollectionAgreed = false;
  bool _ageAgreed = false; // 만 14세 이상 동의
  bool _marketingPushAgreed = false; // 선택
  bool _marketingEmailAgreed = false; // 선택
  bool _marketingSmsAgreed = false; // 선택

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.oauthUserInfo.name ?? '';
    // 회원가입 시 휴대폰은 서버로 보내지 않음. 가입 후 프로필에서 인증 가능.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // 전체 동의 상태 업데이트 (필수 4개 + 선택 마케팅 3개 모두 동의 시 전체 동의)
  void _updateAllAgreed() {
    setState(() {
      _allAgreed =
          _privacyPolicyAgreed &&
          _termsOfServiceAgreed &&
          _dataCollectionAgreed &&
          _ageAgreed &&
          _marketingPushAgreed &&
          _marketingEmailAgreed &&
          _marketingSmsAgreed;
    });
  }

  // 전체 동의 체크박스 처리
  void _onAllAgreedChanged(bool? value) {
    setState(() {
      _allAgreed = value ?? false;
      _privacyPolicyAgreed = _allAgreed;
      _termsOfServiceAgreed = _allAgreed;
      _dataCollectionAgreed = _allAgreed;
      _ageAgreed = _allAgreed;
      _marketingPushAgreed = _allAgreed;
      _marketingEmailAgreed = _allAgreed;
      _marketingSmsAgreed = _allAgreed;
    });
  }

  // 개별 동의 체크박스 처리
  void _onPolicyAgreedChanged(String policyType, bool? value) {
    setState(() {
      switch (policyType) {
        case 'privacy':
          _privacyPolicyAgreed = value ?? false;
          break;
        case 'terms':
          _termsOfServiceAgreed = value ?? false;
          break;
        case 'data':
          _dataCollectionAgreed = value ?? false;
          break;
        case 'age':
          _ageAgreed = value ?? false;
          break;
        case 'marketingPush':
          _marketingPushAgreed = value ?? false;
          break;
        case 'marketingEmail':
          _marketingEmailAgreed = value ?? false;
          break;
        case 'marketingSms':
          _marketingSmsAgreed = value ?? false;
          break;
      }
      _updateAllAgreed();
    });
  }

  // 정책 링크 열기
  void _openPolicyLink(String policyType) {
    String url;
    switch (policyType) {
      case 'privacy':
        url = 'https://ventail.it.kr/privacy.html';
        break;
      case 'terms':
        url = 'https://ventail.it.kr/terms.html';
        break;
      case 'data':
        url = 'https://ventail.it.kr/consent.html';
        break;
      case 'marketingPush':
      case 'marketingEmail':
      case 'marketingSms':
        url = 'https://ventail.it.kr/privacy.html';
        break;
      default:
        return;
    }

    // URL 열기 (url_launcher 패키지 필요)
    launchUrl(Uri.parse(url));
  }

  // 역할 선택 카드
  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required UserRole role,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: AppRadius.radiusMD,
      child: Container(
        padding: AppSpacing.paddingLG,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryWithOpacity10 : AppColors.surface,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.elevation1 : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 32,
            ),
            AppSpacing.verticalSM,
            Text(
              title,
              style: AppTextStyles.subtitle.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
            AppSpacing.verticalXS,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // 정책 체크박스 위젯 생성
  Widget _buildPolicyCheckbox(
    String title,
    bool value,
    String policyType, {
    required bool isRequired,
    required bool moreLinkVisible,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged:
                (newValue) => _onPolicyAgreedChanged(policyType, newValue),
            activeColor: AppColors.primary,
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(child: Text(title, style: AppTextStyles.body1)),
                const SizedBox(width: 4),
                Text(
                  isRequired ? '(필수)' : '(선택)',
                  style: AppTextStyles.caption.copyWith(
                    color:
                        isRequired ? AppColors.error : AppColors.textTertiary,
                    fontWeight:
                        isRequired ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (moreLinkVisible)
            TextButton(
              onPressed: () => _openPolicyLink(policyType),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '보기',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 상단 단계 진행 표시
  /// 구조: [원0] — [선 0→1] — [원1] — [선 1→2] — [원2] (연결선은 구간당 하나)
  Widget _buildStepProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: TweenAnimationBuilder<double>(
        key: ValueKey('step_$_previousStep-$_currentStep'),
        tween: Tween<double>(
          begin: _previousStep.toDouble(),
          end: _currentStep.toDouble(),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, stepValue, _) {
          final children = <Widget>[];
          for (var i = 0; i < _totalSteps; i++) {
            if (i > 0) {
              // 구간 (i-1) → i 를 잇는 선 하나
              final fillRatio = (stepValue - (i - 1)).clamp(0.0, 1.0);
              children.add(Expanded(child: _buildSegmentBar(fillRatio)));
            }
            children.add(_buildStepCircle(i));
          }
          return Row(children: children);
        },
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isCompleted = index < _currentStep;
    final isCurrent = index == _currentStep;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent ? AppColors.primary : AppColors.border,
      ),
      child: Center(
        child:
            isCompleted
                ? Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: AppColors.textOnPrimary,
                )
                : Text(
                  '${index + 1}',
                  style: AppTextStyles.caption.copyWith(
                    color:
                        isCurrent
                            ? AppColors.textOnPrimary
                            : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }

  /// 연결선 한 구간: fillRatio(0~1)만큼 primary, 나머지 border
  Widget _buildSegmentBar(double fillRatio) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return SizedBox(
          height: 2,
          child: Row(
            children: [
              Container(
                width: w * fillRatio,
                height: 2,
                color: AppColors.primary,
              ),
              Container(
                width: w * (1 - fillRatio),
                height: 2,
                color: AppColors.border,
              ),
            ],
          ),
        );
      },
    );
  }

  void _goNextStep() {
    if (_currentStep == 0) {
      setState(() {
        _previousStep = _currentStep;
        _currentStep = 1;
      });
      return;
    }
    if (_currentStep == 1) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      setState(() {
        _previousStep = _currentStep;
        _currentStep = 2;
      });
      return;
    }
  }

  void _goPrevStep() {
    if (_currentStep > 0) {
      setState(() {
        _previousStep = _currentStep;
        _currentStep = _currentStep - 1;
      });
    }
  }

  // 전화번호 형식 검증
  // String? _validatePhoneNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return '전화번호를 입력해주세요';
  //   }
  //   // 하이픈 제거 후 검증
  //   final cleanNumber = value.replaceAll('-', '');
  //   if (!RegExp(r'^01[0-9]{8,9}$').hasMatch(cleanNumber)) {
  //     return '올바른 전화번호 형식이 아닙니다';
  //   }
  //   return null;
  // }

  // 전화번호 인증번호 발송
  // Future<void> _sendVerificationCode() async {
  //   final phoneNumber = _phoneNumberController.text.replaceAll('-', '');
  //   if (_validatePhoneNumber(phoneNumber) != null) return;

  //   setState(() => _isVerifying = true);

  //   try {
  //     // TODO: 실제 인증번호 발송 API 호출
  //     // 임시로 6자리 랜덤 코드 생성
  //     _verificationCode = (100000 + Random().nextInt(900000)).toString();
  //     logger.d('인증번호: $_verificationCode'); // 개발용 로그

  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('인증번호가 발송되었습니다')));
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('인증번호 발송 실패: $e')));
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isVerifying = false);
  //     }
  //   }
  // }

  // 인증번호 확인
  // void _verifyCode() {
  //   if (_verificationCode == null) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('인증번호를 먼저 발송해주세요')));
  //     return;
  //   }

  //   if (_verificationCodeController.text == _verificationCode) {
  //     setState(() => _isVerified = true);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('인증이 완료되었습니다')));
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('인증번호가 일치하지 않습니다')));
  //   }
  // }

  /// 뒤로가기 버튼 처리 (OAuth 연결 해제)
  Future<void> _handleBackButton(BuildContext context) async {
    // 확인 다이얼로그 표시
    final shouldRevoke = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            title: const Text('회원가입 취소', style: AppTextStyles.heading2),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입을 취소하시겠습니까?',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '취소하시면 ${_getProviderName(widget.oauthUserInfo.provider)} 계정 연결이 해제됩니다.',
                  style: AppTextStyles.body2,
                ),
                if (widget.oauthUserInfo.provider == 'apple') ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Apple 로그인은 재로그인 시 정보를 제공하지 않습니다.\n'
                            '재로그인 시 문제가 발생할 수 있습니다.',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('계속하기', style: AppTextStyles.body2),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('취소하기', style: AppTextStyles.button),
              ),
            ],
          ),
    );

    if (shouldRevoke == true) {
      // OAuth 연결 해제
      await _revokeOAuthConnection();

      if (mounted) {
        context.go(LoginScreen.path);
      }
    }
  }

  /// OAuth 제공자 이름 반환
  String _getProviderName(String provider) {
    switch (provider) {
      case 'google':
        return '구글';
      case 'apple':
        return 'Apple';
      case 'naver':
        return '네이버';
      case 'kakao':
        return '카카오';
      default:
        return provider;
    }
  }

  /// OAuth 연결 해제
  Future<void> _revokeOAuthConnection() async {
    try {
      final oauthRepository = ref.read(oauthRepositoryProvider);
      await oauthRepository.revoke(widget.oauthUserInfo.provider);
      logger.d('${widget.oauthUserInfo.provider} 연결 해제 성공');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_getProviderName(widget.oauthUserInfo.provider)} 계정 연결이 해제되었습니다',
            ),
            backgroundColor: Colors.grey.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      logger.e('OAuth 연결 해제 실패: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(toUserFriendlyMessage(e)),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    // 필수 정책 동의 확인
    if (!_privacyPolicyAgreed ||
        !_termsOfServiceAgreed ||
        !_dataCollectionAgreed ||
        !_ageAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('필수 정책에 동의해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authViewModel = ref.read(authViewModelProvider.notifier);
      await authViewModel.signup(
        widget.oauthUserInfo,
        _nicknameController.text,
        _selectedRole,
        phoneNumber: null, // 회원가입 시 휴대폰은 서버로 전송하지 않음
        marketingPushAgreed: _marketingPushAgreed,
        marketingEmailAgreed: _marketingEmailAgreed,
        marketingSmsAgreed: _marketingSmsAgreed,
      );
      if (!mounted) return;
      context.go(
        _selectedRole == UserRole.owner
            ? OwnerMainScreen.path
            : WalkerMainScreen.path,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(toUserFriendlyMessage(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepRole();
      case 1:
        return _buildStepProfile();
      case 2:
        return _buildStepPolicy();
      default:
        return _buildStepRole();
    }
  }

  Widget _buildStepRole() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          '역할 선택',
          style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                title: '오너',
                subtitle: '반려견을 맡기고 싶어요',
                role: UserRole.owner,
                icon: Icons.pets,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRoleCard(
                title: '워커',
                subtitle: '반려견을 돌봐주고 싶어요',
                role: UserRole.walker,
                icon: Icons.directions_walk,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildPrimaryButton(label: '다음', onPressed: _goNextStep),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStepProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          labelText: '이름',
          readOnly: true,
          fillColor: Colors.grey.shade200,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppColors.textLight,
            size: 20,
          ),
          textStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: AppTextStyles.subtitle.copyWith(
            color: AppColors.textSecondary,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '이름을 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: _nicknameController,
          labelText: '닉네임',
          hintText: '2~10자의 닉네임을 입력해주세요',
          inputFormatters: [
            // 프로필 수정과 동일: 천지인 등에서 '.' 입력 시 사용하는 문자(·, • 등) 허용
            FilteringTextInputFormatter.allow(
              RegExp(
                r'[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣᆞᆢᆨᆫᆮᆯᆷᆸᆺᆻᆼᆽᆾᆿᇀᇁᇂ\u318D\u119E\u11A2\u2022\u2027\u00B7\u30FB]',
              ),
            ),
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '닉네임을 입력해주세요.';
            }
            if (value.length < 2) {
              return '닉네임은 2자 이상 입력해주세요.';
            }
            if (!RegExp(r'^[a-zA-Z0-9가-힣]+$').hasMatch(value.trim())) {
              return '닉네임은 영문, 숫자, 완성된 한글만 입력 가능합니다';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: _phoneNumberController,
          labelText: '전화번호',
          hintText: '가입 후 프로필 수정에서 인증 가능',
          readOnly: true,
          fillColor: Colors.grey.shade200,
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.textTertiary,
            size: 20,
          ),
          textStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: AppTextStyles.subtitle.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _goPrevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: '다음',
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  _goNextStep();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStepPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: AppSpacing.paddingLG,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radiusMD,
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('정책 동의', style: AppTextStyles.title),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _allAgreed,
                      onChanged: _onAllAgreedChanged,
                      activeColor: AppColors.primary,
                    ),
                    const Expanded(
                      child: Text('전체 동의', style: AppTextStyles.body1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildPolicyCheckbox(
                '개인정보처리방침',
                _privacyPolicyAgreed,
                'privacy',
                isRequired: true,
                moreLinkVisible: true,
              ),
              _buildPolicyCheckbox(
                '이용약관',
                _termsOfServiceAgreed,
                'terms',
                isRequired: true,
                moreLinkVisible: true,
              ),
              _buildPolicyCheckbox(
                '개인정보 수집 및 이용 동의',
                _dataCollectionAgreed,
                'data',
                isRequired: true,
                moreLinkVisible: true,
              ),
              _buildPolicyCheckbox(
                '만 14세 이상 이용 동의',
                _ageAgreed,
                'age',
                isRequired: true,
                moreLinkVisible: false,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 1,
                color: Colors.grey.shade300,
              ),
              Text(
                '마케팅 수신 동의 (선택)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildPolicyCheckbox(
                '앱 알림(푸시)',
                _marketingPushAgreed,
                'marketingPush',
                isRequired: false,
                moreLinkVisible: false,
              ),
              _buildPolicyCheckbox(
                '이메일',
                _marketingEmailAgreed,
                'marketingEmail',
                isRequired: false,
                moreLinkVisible: false,
              ),
              _buildPolicyCheckbox(
                'SMS',
                _marketingSmsAgreed,
                'marketingSms',
                isRequired: false,
                moreLinkVisible: false,
              ),
              const SizedBox(height: 12),
              const Text(
                '필수 항목에 동의해야 회원가입이 가능합니다.',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _goPrevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  '이전',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                label: _isLoading ? '가입 중...' : '회원가입',
                onPressed: _isLoading ? null : _handleSignup,
                showLoading: _isLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    VoidCallback? onPressed,
    bool showLoading = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.radiusMD,
        boxShadow: AppShadows.primaryButton,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.radiusMD,
          child: Center(
            child:
                showLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      label,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textOnPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentStep > 0) {
          _goPrevStep();
          return;
        }
        await _handleBackButton(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
            onPressed:
                _isLoading
                    ? null
                    : () async {
                      if (_currentStep > 0) {
                        _goPrevStep();
                        return;
                      }
                      await _handleBackButton(context);
                    },
          ),
          title: Text('회원가입', style: AppTextStyles.heading3),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStepProgress(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Form(key: _formKey, child: _buildStepContent()),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('회원가입 중...', style: AppTextStyles.body1),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
