import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'local_data/app_state.dart';
import 'model/api_response.dart';
import 'model/draft_model.dart';
import 'model/model.dart';
import 'model/question_item.dart';
import 'service/common_service.dart';
import 'service/database/database_helper.dart';

bool isLight = true;
bool isQuickPost = false;
AppState appState = AppState();
DatabaseHelper databaseHelper = DatabaseHelper();
CommonService commonService = CommonService();

class App {
  static const app_name = "Sylo";
  static const revenue_cart_key = "cSxaAyZSBQiRTnvRfMCUCRuHNUBzpzoG";
  static const font_name = "AvenirLTStd";
  static const currency = "\$";
  static const pound_currency = "£";
  static const status_only_record_trim = "status_only_record_trim";
  static const lorem =
      "101 Questions to ask yourself when raising more than one child";
  static const lorem2 =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
  static const lorem3 =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ";
  static const notifyInfoToolTip =
      "By selecting this option your Sylo Recipient will be emailed a link to share viewing access to this Sylo and its content.";
  static const videoPreviewQuestions =
      "What advice would you give a younger version of yourself?";
  static const promptsTopLabel =
      "With Sylo's Qcam™ you can load customisable Prompts to help you record your video.";
  static String dot = "•";
  static String errorEmail = "Enter email";
  static String errorEmailOnly = "Enter email";
  static String errorNameOnly = "Enter name";
  static String errorMobileOnly = "Enter mobile no.";
  static String errorPassword = "Enter password";
  static String errorNameInValid = "Enter valid name";
  static String errorEmailInValid = "Enter valid email address";
  static String errorMobileInValid = "Enter valid mobile number";

  static String errorCompNameOnly = "Enter your company name";
  static String errorCompAddeOnly = "Enter your company address";
  static String errorOldPwdRequired = "Enter your old password";
  static String errorNewPwdRequired = "Enter your new password";
  static String errorConfirmPwdRequired = "Enter password again";
  static String errorPwdMismatch = "Password mismatch";

  static String errorFieldRequired = "This field is required";
  static String txtSomethingWentWrong =
      "Something went wrong. Try again in a few minutes.";
  static String emailVerificationInstruction =
      "Please check your email and follow the instruction to reset your password.";
  static String emailVerificationInstructionOnSignup =
      "Please check your email and follow the instruction to signUp process.";
  static String openMessageSyloInstruction =
      "This is the first TimePost your Recipient will see when they eventually receive this Sylo";
  static String inactivityPeriodInstruction =
      "We will notify your Assigned Sylo Recipients after the inactivity Period below is reached";
  static String inactivityPeriodBannerInstruction =
      "It is very important that you sign in regularly to prevent this Inactivity Period from lapsing unintentionally or else your Sylos will be shared with all your Assigned Recipients.";
  static String helpInfoInstruction =
      "You can also browse the topics below to find what you are looking for";
  static String rePostInstruction =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
  static String songInstruction = "Simply select and copy the song's link.";
  static String postInstruction = "Simply select and copy the post's link.";

  static const List<String> mediaItem = [
    "video",
    "image",
    "audio",
    "music",
    "text"
  ];
  static const List<String> notificationStatus = [
    "Success",
    "Rejected",
    "Alert"
  ];
  static const Map<String, String> MediaTypeMap = {
    'video': 'VIDEO',
    'photo': 'PHOTO',
    'songs': 'SONGS',
    'repost': 'REPOST',
    'audio': 'AUDIO',
    'text': 'TEXT',
    'vtag': 'VTAG',
    'qcast': 'QCAST',
  };
  //static String errorCompGSTOnly = "Enter your GST number";

  static const formatYYmd = 'dd MMM, yyyy hh:mm a';
  static const formatDdMMMYY = 'dd MMM, yyyy';
  static const formatMMMDDYY = 'MMM dd, yyyy';
  static const format12hr = 'hh:mm a';
  static const formatDate12hr = 'dd/MM hh:mm a';
  static const formatDate = 'dd/MM';
  static const formatDateWithTime = 'dd/MM/yyyy – kk:mm';
  static const formatDateForAddSylo = 'dd/MM/yyyy';
  static const formatDateForADD = 'DD/MM/YYYY';

  static String getDateFormate(DateTime dateTime) {
    return DateFormat(formatYYmd).format(dateTime);
  }

  static String getDateByFormat(DateTime dateTime, String format) {
    if (dateTime == null) return "";
    //print("language -> "+appState.language);
    return DateFormat(format).format(dateTime);
  }

  static const root = 'assets/icon/';
  static const ic_placeholder = '$root' + 'ic_placeholder.png';
  static const ic_banner = '$root' + 'ic_banner.png';
  static const ic_place = '$root' + 'ic_place.png';
  static const ic_temp = '$root' + 'ic_temp.png';
  static const ic_temp_theme = '$root' + 'ic_temp_theme.png';
  static const ic_q = '$root' + 'ic_q.png';
  static const ic_q_white = '$root' + 'ic_q_white.png';
  static const ic_sq = '$root' + 'ic_sq.png';
  static const ic_right = '$root' + 'ic_right.png';
  static const ic_play = '$root' + 'ic_play.png';
  static const ic_change_cam = '$root' + 'ic_change_cam.png';
  static const ic_pause = '$root' + 'ic_pause.png';
  static const ic_q_prompts = '$root' + 'ic_q_prompts.png';
  static const ic_place_profile = '$root' + 'ic_place_profile.png';
  static const ic_cam = '$root' + 'ic_cam.png';
  static const ic_lib = '$root' + 'ic_lib.png';
  static const ic_video = '$root' + 'ic_video.png';
  static const ic_mail_sent = '$root' + 'ic_mail_sent.png';
  static const img_splash = '$root' + 'img_splash.png';
  static const img_sylo = '$root' + 'img_sylo.png';
  static const img_color_sylo = '$root' + 'img_color_sylo.png';
  static const img_sub = '$root' + 'img_sub.png';
  static const ic_launcher = '$root' + 'ic_launcher.png';
  static const ic_google = '$root' + 'ic_google.png';
  static const ic_fb = '$root' + 'ic_fb.png';
  static const ic_person = '$root' + 'ic_person.png';
  static const img_onboarding1 = '$root' + 'img_onboarding1.png';
  static const img_onboarding2 = '$root' + 'img_onboarding2.png';
  static const img_onboarding3 = '$root' + 'img_onboarding3.png';
  static const img_purple_rectangle = '$root' + 'img_purple_rectangle.png';
  static const ic_play_outline = '$root' + 'ic_play_outline.png';
  static const ic_heart = '$root' + 'ic_heart.png';
  static const ic_play_pink = '$root' + 'ic_play_pink.png';
  static const ic_group_info = '$root' + 'ic_group_info.png';
  static const ic_create_album = '$root' + 'ic_create_album.png';
  static const ic_empty_album = '$root' + 'ic_empty_album.png';
  static const ic_info = '$root' + 'ic_info.png';
  static const ic_eye = '$root' + 'ic_eye.png';
  static const ic_add = '$root' + 'ic_add.png';
  static const ic_alert_new = '$root' + 'ic_alert_new.png';
  static const ic_tab1 = '$root' + 'ic_tab1.png';
  static const ic_tab1_s = '$root' + 'ic_tab1_s.png';
  static const ic_tab2 = '$root' + 'ic_tab2.png';
  static const ic_tab2_S = '$root' + 'ic_tab2_s.png';
  static const ic_tab3 = '$root' + 'ic_tab3.png';
  static const ic_tab3_S = '$root' + 'ic_tab3_s.png';
  static const ic_tab4 = '$root' + 'ic_tab4.png';
  static const ic_back = '$root' + 'ic_back.png';
  static const ic_back_white = '$root' + 'ic_back_white.png';
  static const ic_tab4_S = '$root' + 'ic_tab4_s.png';
  static const ic_logo_white = '$root' + 'ic_logo_white.png';
  static const img_sylo_icon = '$root' + 'img_sylo_icon.png';
  static const ic_logo_purple = '$root' + 'ic_logo_purple.png';
  static const ic_edit_album = '$root' + 'ic_edit_album.png';
  static const ic_refresh_album = '$root' + 'ic_refresh_album.png';
  static const ic_music_album = '$root' + 'ic_music_album.png';
  static const ic_images_album = '$root' + 'ic_images_album.png';
  static const ic_mic = '$root' + 'ic_mic.png';
  static const ic_mic_white = '$root' + 'ic_mic_white.png';
  static const ic_mic_record = '$root' + 'ic_mic_record.png';
  static const ic_delete_drafts = '$root' + 'ic_delete_drafts.png';
  static const ic_sylo_pick = '$root' + 'ic_sylo_pick.png';
  static const ic_logout_acc = '$root' + 'ic_logout_acc.png';
  static const ic_billing_acc = '$root' + 'ic_billing_acc.png';
  static const ic_notification_acc = '$root' + 'ic_notification_acc.png';
  static const ic_security_acc = '$root' + 'ic_security_acc.png';
  static const ic_inact_acc = '$root' + 'ic_inact_acc.png';
  static const ic_help_acc = '$root' + 'ic_help_acc.png';
  static const ic_feedback = '$root' + 'ic_feedback.png';
  static const ic_deliver_sylo_info = '$root' + 'ic_deliver_sylo_info.png';
  static const ic_faq = '$root' + 'ic_faq.png';
  static const ic_invite_contacts = '$root' + 'ic_invite_contacts.png';
  static const ic_billing_cloud = '$root' + 'ic_billing_cloud.png';
  static const ic_success_noti = '$root' + 'ic_success_noti.png';
  static const ic_rejected_noti = '$root' + 'ic_rejected_noti.png';
  static const ic_update_noti = '$root' + 'ic_update_noti.png';
  static const ic_finger_print_security =
      '$root' + 'ic_finger_print_security.png';
  static const ic_face_security = '$root' + 'ic_face_security.png';
  static const ic_mic_coloroval = '$root' + 'ic_mic_coloroval.png';
  static const ic_image_pick = '$root' + 'ic_image_pick.png';
  static const ic_round_record = '$root' + 'ic_round_record.png';
  static const ic_fb_round = '$root' + 'ic_fb_round.png';
  static const ic_insta = '$root' + 'ic_insta.png';
  static const ic_twitter = '$root' + 'ic_twitter.png';
  static const ic_utube = '$root' + 'ic_utube.png';
  static const ic_itunes = '$root' + 'ic_itunes.png';
  static const ic_soptify = '$root' + 'ic_soptify.png';
  static const ic_soundcloud = '$root' + 'ic_soundcloud.png';
  static const ic_utube_music = '$root' + 'ic_utube_music.png';
  static const ic_wave = '$root' + 'wave.gif';
  static const ic_big_wave = '$root' + 'big_wave.gif';
  static const ic_family = '$root' + 'ic_family.png';
  static const ic_identity = '$root' + 'ic_identity.png';
  static const ic_mentoring = '$root' + 'ic_mentoring.png';
  static const ic_sports = '$root' + 'ic_sports.png';
  static const ic_politics = '$root' + 'ic_politics.png';
  static const ic_health = '$root' + 'ic_health.png';
  static const ic_education = '$root' + 'ic_education.png';
  static const ic_faith = '$root' + 'ic_faith.png';
  static const ic_career = '$root' + 'ic_career.png';
  static const ic_entertainment = '$root' + 'ic_entertainment.png';
  static const ic_family_history = '$root' + 'ic_family_history.png';
  static const ic_love = '$root' + 'ic_love.png';
  static const ic_mark_email_read = '$root' + 'ic_mark_email_read.png';
  static const ic_mark_email_unread = '$root' + 'ic_mark_email_unread.png';
  static const img_home_bg = '$root' + 'img_home_bg.png';
  static const ic_alert = '$root' + 'ic_alert_new.png';
  static const ic_success_alert = '$root' + 'ic_success_alert.png';
  static const ic_thumb = '$root' + 'ic_thumb.png';
  static const ic_secure_lock = '$root' + 'ic_secure_lock.png';
  static const ic_onboarding_one = '$root' + 'ic_onboarding_one.png';
  static const ic_onboarding_two = '$root' + 'ic_onboarding_two.png';
  static const ic_onboarding_three = '$root' + 'ic_onboarding_three.png';
  // api
  static const editAlbumName = 'updateAlbum'; //api route for album name edit
  static const deleteAlbum = 'deleteAlbum'; //api route for album name edit
  static const createUserFeedback =
      'saveUserFeedback'; // api route to create new user feedback
  static const copymoveAlbum =
      'transferAlbumData'; // api route to copy move feedback
  static const deliverSylo = 'markAndReleaseSylos'; // api release sylo
  static const getUserCloudStorage =
      'getUserSpaceOnCloud'; // api get user used storage
  static const getSubPackages = 'getPackageDetails';
  static const getUserSubDetails = 'getCloudSubscriptionDetails';

  static const apiSignInProcess = 'signInProcess';
  static const apiForgetPassword = 'forgetPassword';
  static const callAddUser = 'addUser';
  static const callVerifyEmailWithCode = 'verifyEmailWithCode';
  static const resendCode = 'resendCode';
  static const changePassword = 'changePassword';
  static const addSylo = 'addSylo';
  static const getSyloMediaByType = 'getSyloMediaByType';
  static const getUserSylos = 'getUserSylos';
  static const uploadGetMediaID = 'uploadGetMediaID';
  static const uploadGetMediaIDSyn = 'uploadGetMediaIDSyn';
  static const createAlbum = 'createAlbum';
  static const getAllAlbumsForSylo = 'getAllAlbumsForSylo';
  static const updateUser = 'updateUser';
  static const createMediaSubAlbum = 'createMediaSubAlbum';
  static const uploadVideoWithCoverPic = 'uploadVideoWithCoverPic';
  static const getAlbumMediaData = 'getAlbumMediaData';
  static const getSubAlbumData = 'getSubAlbumData';
  static const verifyEmailAddress = 'verifyEmailAddress';
  static const addMyChannelProfile = 'addMyChannelProfile';
  static const updateMyChannelProfile = 'updateMyChannelProfile';
  static const getMyChannelProfile = 'getMyChannelProfile';
  static const getSharedSylos = 'getSharedSylos';
  static const askSyloQuestions = 'askSyloQuestions';
  static const getSyloMediaCount = 'getSyloMediaCount';
  static const getSyloQuestions = 'getSyloQuestions';
  static const getQcastByUser = 'getQcastByUser';
  static const addQcast = 'addQcast';
  static const publishQcast = 'publishQcast';
  static const getQcastDashboard = 'getQcastDashboard';
  static const unSubscribeUser = 'unSubscribeUser';
  static const subscribeUser = 'subscribeUser';
  static const getQcastByCategory = 'getQcastByCategory';
  static const getQcastDeepCopy = 'getQcastDeepCopy';
  static const downloadQcast = 'downloadQcast';
  static const getMyDownloadedQcasts = 'getMyDownloadedQcasts';
  static const getPrompts = 'getPrompts';
  static const saveCustomPrompt = 'saveCustomPrompt';
  static const getOrUpdateIP = 'getOrUpdateIP';
  static const getNotifications = 'getNotifications';
  static const markReadFlag = 'markReadFlag';
  static const deleteNotification = 'deleteNotification';
  static const getAllAlbumsForSyloList = 'getAllAlbumsForSyloList';
  static const deleteSubAlbum = 'deleteSubAlbum';
  static const getSyloDeepCopy = 'getSyloDeepCopy';
  static const deleteSylo = 'deleteSylo';
  static const updateSylo = 'updateSylo';
  static const getFaqs = 'getFaqs';
  static const searchFaq = 'searchFaq';
  static const changeNotifySetting = 'changeNotifySetting';
  static const addToQcast = 'addToQcast';
  static const addSyloEmail = 'checkAddSyloEmail';
  static const changeQcastStatus = 'changeQcastStatus';

  static Route createRoute({Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastLinearToSlowEaseIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

getColorLabel() {
  if (isLight) {
    return colorTextHead;
  } else {
    return Colors.white;
  }
}

getColorIcon() {
  if (isLight) {
    return getColorPrimary();
  } else {
    return Colors.white;
  }
}

Color BLUE_NORMAL = Color(0xff54c5f8);
Color GREEN_NORMAL = Color(0xff6bde54);
Color BLUE_DARK2 = Color(0xff01579b);
Color BLUE_DARK1 = Color(0xff29b6f6);
Color RED_DARK1 = Color(0xfff26388);
Color RED_DARK2 = Color(0xfff782a0);
Color RED_DARK3 = Color(0xfffb8ba8);
Color RED_DARK4 = Color(0xfffb89a6);
Color RED_DARK5 = Color(0xfffd86a5);
Color YELLOW_NORMAL = Color(0xfffcce89);

getColorBg() {
  if (isLight) {
    //return Color(0x00ffFFF9F9);
    return Colors.white;
  } else {
    return Color(0x00ffFFF9F9);
  }
}

getMatColorBg() {
  if (isLight) {
    return Colors.white;
  } else {
    return Colors.white;
  }
}

Color colorHomeBg = Color(0x00ffE1DAEB);
Color colorBg = Color(0x00ffF9F9F9);
Color colorBg1 = Color(0x00ffECE8F2);
Color colorTextHead = Color(0x00ff191B21);
Color colorBrown = Colors.brown;
Color colorTextPara = Color(0x00ff73777F);
Color colorSectionHead = Color(0x00ff9F00C5);
Color colorDark = Color(0x00ff4E2A84);
Color colorOvalBorder2 = Color(0x00ff940BC7);
Color colorgradient = Color(0x00ff9F00c5);
Color colorgradient1 = Color(0x00ff4E2A84);
Color colorOvalBorder = Color(0x00ffECE8F2);
Color colorLightRound = Color(0x00ffECE8F2);
Color colorHover = Color(0x00ff8BC33C);
Color colorBlack = Color(0x00ff000000);
Color colorWhite = Color(0x00ffffffff);
Color colorlightPurple = Color(0xffd8adf3);
Color colorDarkPurple = Color(0xffae51e8);
Color colorSelectedItem = Color(0x00ffB6E8DC);
Color colorSelectedMenu = Colors.green[300];
Color colorSubTextPera = Color(0x00ff878787);
Color colorDisable = Color(0x00ffC3C3C3);
Map<int, Color> colorMat = {
  50: Color.fromRGBO(65, 20, 139, .1),
  100: Color.fromRGBO(65, 20, 139, .2),
  200: Color.fromRGBO(65, 20, 139, .3),
  300: Color.fromRGBO(65, 20, 139, .4),
  400: Color.fromRGBO(65, 20, 139, .5),
  500: Color.fromRGBO(65, 20, 139, .6),
  600: Color.fromRGBO(65, 20, 139, .7),
  700: Color.fromRGBO(65, 20, 139, .8),
  800: Color.fromRGBO(65, 20, 139, .9),
  900: Color.fromRGBO(65, 20, 139, 1),
};

getColorPrimary() {
  if (isLight) {
    return MaterialColor(0x00ff370C75, colorMat);
  } else {
    return Colors.green;
  }
}

getColorBorder() {
  if (isLight) {
    return Colors.green;
  } else {
    return Colors.green;
  }
}

getTextStyle(
    {Color color,
    double size,
    FontWeight fontWeight,
    TextDecoration textDecoration,
    double height}) {
  return TextStyle(
    fontSize: size ?? 14,
    fontFamily: App.font_name,
    decoration: textDecoration ?? TextDecoration.none,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color ?? getColorLabel(),
    height: height ?? height,
  );
}

List<RelationModel> relationshipFamilyList = [
  RelationModel(
    text: "Wife",
    index: 0,
  ),
  RelationModel(
    text: "Husband",
    index: 1,
  ),
  RelationModel(
    text: "Partner",
    index: 2,
  ),
  RelationModel(
    text: "Daughter",
    index: 3,
  ),
  RelationModel(
    text: "Son",
    index: 4,
  ),
  RelationModel(
    text: "Sibling",
    index: 5,
  ),
  RelationModel(
    text: "Parent",
    index: 6,
  ),
  RelationModel(
    text: "Other",
    index: 7,
  ),
];

List<RelationModel> relationshipList = [
  RelationModel(
    text: "Family",
    index: 0,
  ),
  RelationModel(
    text: "Friend",
    index: 1,
  ),
  RelationModel(
    text: "Mentee",
    index: 2,
  ),
  RelationModel(
    text: "Business Partner",
    index: 3,
  ),
];

List<ThemeModel> themeModelList = [
  ThemeModel(
    title: "Family",
    icon: App.ic_family,
    description:
        "Questions about your nearest and dearest as well as tough questions for broken families.",
  ),
  ThemeModel(
    title: "Identity",
    icon: App.ic_identity,
    description:
        "Who are you really? Questions to help you share yourself with others.",
  ),
  ThemeModel(
    title: "Finances",
    icon: App.ic_temp_theme,
    description:
        "Questions to help you offer honest advice on the do's and don't of money.",
  ),
  ThemeModel(
    title: "Mentoring ",
    icon: App.ic_mentoring,
    description:
        "Questions for mentors who have mentees you wish to inspire and guide.",
  ),
  ThemeModel(
    title: "Sports",
    icon: App.ic_sports,
    description:
        "Questions for sporty folk to evoke stories of the love you have for sport.",
  ),
  ThemeModel(
    title: "Politics",
    icon: App.ic_politics,
    description: "Questions to help you share your political beliefs.",
  ),
  ThemeModel(
    title: "Health",
    icon: App.ic_health,
    description: "Questions to help you share why health is important to you.",
  ),
  ThemeModel(
    title: "Education",
    icon: App.ic_education,
    description:
        "Questions to evoke your feelings of about education; its benefits (or not)",
  ),
  ThemeModel(
    title: "Faith",
    icon: App.ic_faith,
    description:
        "Questions about why you believe what you do, or why you don't.",
  ),
  ThemeModel(
    title: "Career",
    icon: App.ic_career,
    description:
        "Questions to help you understand your career path you took, or didn't take.",
  ),
  ThemeModel(
    title: "Entertainment",
    icon: App.ic_entertainment,
    description: "Questions about your favorite movies and shows.",
  ),
  ThemeModel(
    title: "Family History",
    icon: App.ic_family_history,
    description: "Questions to help you share your Family Tree.",
  ),
  ThemeModel(
    title: "Love",
    icon: App.ic_love,
    description:
        "Questions about falling in and out of love, and the priceless advice your gained.",
  ),
];

List<MediaItemModel> albumItemList = [
  MediaItemModel("John Elder", App.mediaItem[0]),
  MediaItemModel("John Elder", App.mediaItem[1]),
  MediaItemModel("John Elder", App.mediaItem[2]),
  MediaItemModel("John Elder", App.mediaItem[3]),
  MediaItemModel("John Elder", App.mediaItem[4]),
  MediaItemModel("John Elder", App.mediaItem[0]),
  MediaItemModel("John Elder", App.mediaItem[1]),
  MediaItemModel("John Elder", App.mediaItem[2]),
  MediaItemModel("John Elder", App.mediaItem[3]),
  MediaItemModel("John Elder", App.mediaItem[4]),
];

enum SoundTapState { None, R, S, L }
enum MediaPostTapState { None, V, S, P, M, R, T }
enum RePostApplication { None, F, I, T, Y }
enum SongsApplication { None, S, Y, I, SC }

getTapBackColor(bool isTrue, Color defaultColor) {
  return LinearGradient(
    colors: !isTrue
        ? [defaultColor, defaultColor]
        : [
            Color(0xff9F00C5),
            Color(0xff9405BD),
            Color(0xff7913A7),
            Color(0xff651E96),
            Color(0xff522887)
          ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

getTapBackColorTint(bool isTrue, Color defaultColor) {
  return LinearGradient(
    colors: !isTrue
        ? [defaultColor, defaultColor]
        : [
      Color(0xffffffff),
      Color(0xffffffff),
      Color(0xffffffff),
      Color(0xffffffff),
      Color(0xffffffff)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

getTapBackGradientIconColor(bool isTrue, Color defaultColor) {
  return LinearGradient(
    colors: !isTrue
        ? [defaultColor, defaultColor]
        : [
            Color(0xff9F00C5),
            Color(0xff9405BD),
          ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

getTapWhiteIconColor(bool isTrue, Color defaultColor) {
  if (isTrue)
    return Colors.white;
  else
    return defaultColor;
}

getTapWhiteIconColorTint(bool isTrue, Color defaultColor) {
  if (isTrue)
    return defaultColor;
  else
    return Colors.white;
}

getTapWhiteLabelColor(bool isTrue, Color defaultColor) {
  if (isTrue)
    return Colors.white;
  else
    return defaultColor;
}

int startDur = 150, endDur = 300;

enum CameraState { R, S }

getCamSquareViewByState() {}

getTagString(List<TagModel> tagList) {
  List<String> tagNameList = List();
  tagList.forEach((element) {
    tagNameList.add(element.name);
  });
  return tagNameList.join(",");
}

List<TagModel> getTagFromString(String tagStr) {
  List<TagModel> tagList = List();
  if (tagStr != null && tagStr.isNotEmpty) {
    List<String> tagItemList = tagStr.split(',');
    tagItemList.forEach((tag) {
      tagList.add(TagModel(name: tag));
    });
  }
  return tagList;
}

getAlbumIdList(List<GetAlbum> albums) {
  List<int> albumIds = List();
  albums.forEach((element) {
    albumIds.add(element.albumId);
  });
  return albumIds;
}

getWHByDeviceRatio(double ratio, w) {
  print("getWHByDeviceRatio -> " + ratio.toString());
  if (ratio > 3) {
    return w / 1.25;
  } else if (ratio > 2) {
    return w / 1.05;
  } else {
    return w / 1.2;
  }
}

getAppNameFromLink(String link) {
  if (link.contains("music.youtube")) {
    return "YouTube Music";
  } else if (link.contains("youtube") || link.contains("youtu.be")) {
    return "YouTube";
  } else if (link.contains("spotify.com")) {
    return "Spotify";
  } else if (link.contains("soundcloud.com")) {
    return "Soundcloud";
  } else if (link.contains("music.apple.com")) {
    return "iTunes";
  } else if (link.contains("facebook.com")) {
    return "Facebook";
  } else if (link.contains("twitter.com")) {
    return "Twitter";
  } else if (link.contains("instagram.com")) {
    return "Instagram";
  } else {
    return "";
  }
}

Future<Uint8List> generateThumbnailFromVideo(File file) async {
  final String _videoPath = file.path;
  VideoPlayerController controller = VideoPlayerController.file(file);
  await controller.initialize();
  double _eachPart = controller.value.duration.inMilliseconds / 10;

  Uint8List _bytes;
  _bytes = await VideoThumbnail.thumbnailData(
    video: _videoPath,
    imageFormat: ImageFormat.JPEG,
    timeMs: (_eachPart * 1).toInt(),
    quality: 50,
  );

  return _bytes;
}

Future<Uint8List> generateThumbnailFromVideoNew(File file) async {
  final String _videoPath = file.path;

  Uint8List _bytes;
  _bytes = await VideoThumbnail.thumbnailData(
    video: _videoPath,
    imageFormat: ImageFormat.JPEG,
    quality: 50,
  );

  return _bytes;
}

initializeSyloItems(List<GetUserSylos> userSylosList) {
  userSylosList.forEach((element) {
    if (element.isCheck) {
      element.isCheck = false;
    }
  });
  return userSylosList;
}

getListOfSelectedSylo(List<GetUserSylos> userSylosList) {
  List<GetUserSylos> selectedSylo =
      userSylosList.where((item) => item.isCheck == true).toList();
  return selectedSylo;
}

getNameFromServerLink(String link) {
  link = link.toString().split("/").last;
  if (link.isNotEmpty) {
    link = link.split("-").last;
  }
  print(link);
  return link;
}

Future<List<String>> savePhotoAsDraft(
    {MyDraft myDraft, List<PostPhotoModel> photoList}) async {
  MyDraftMedia myDraftMedia;
  List<String> mediaList = List();
  print("photo List length ->" + photoList.length.toString());
  int draftId = await databaseHelper.insert(myDraft);
  print("Saved draft with id -->" + draftId.toString());
  if (draftId != null) {
    for (int i = 0; i < photoList.length; i++) {
      myDraftMedia = MyDraftMedia.fromPostPhotoModel(photoList[i]);
      myDraftMedia.draftId = draftId;
      int mediaId = await databaseHelper.insertMedia(myDraftMedia);
      if (mediaId != null) {
        mediaList.add(mediaId.toString());
      }
    }
    print("Saved media Ids ->" + mediaList.join("|"));
  }
  return mediaList;
}

Future<int> saveAsDraft(MyDraft myDraft) async {
  int draftId = await databaseHelper.insert(myDraft);
  print("Saved draft with id -->" + draftId.toString());
  return draftId;
}

List<QuestionItem> getQcastQuestionListFromDraftString(MyDraft myDraft) {
  List<QuestionItem> listQuestion = List();
  List<String> qcastQueList = myDraft.qcastQuestionList.split(",");
  if (qcastQueList.length > 0) {
    qcastQueList.forEach((queLink) {
      listQuestion.add(
          QuestionItem(que_link: queLink, que_thumb: myDraft.qcastCoverPhoto));
    });
  }
  return listQuestion;
}
