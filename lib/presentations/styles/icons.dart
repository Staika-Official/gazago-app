import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/presentations/styles/colors.dart';

// Common Icons
SvgPicture iconSplashLogo = SvgPicture.asset('assets/images/common/img_splash_logo.svg', width: 261, height: 61.15);
SvgPicture iconPlus = SvgPicture.asset('assets/images/common/ico_plus.svg', width: 10.sp, height: 10.sp);
SvgPicture iconSliderShoe = SvgPicture.asset('assets/images/common/ico_slider_shoe.svg', width: 14.7.sp, height: 16.sp);
SvgPicture iconSliderStamina = SvgPicture.asset('assets/images/common/ico_slider_stamina.svg', width: 13.33.sp, height: 20.8.sp);
SvgPicture iconCopy = SvgPicture.asset('assets/images/common/ico_copy.svg', width: 12.33.sp, height: 14.2.sp);
SvgPicture iconExclamationMark = SvgPicture.asset('assets/images/common/ico_circle_exclamation_mark.svg', width: 78.sp, height: 78.sp);
SvgPicture iconArrowDown = SvgPicture.asset('assets/images/common/ico_arrow_down.svg', width: 6.2.sp, height: 6.2.sp);
SvgPicture iconSelectArrowDown = SvgPicture.asset('assets/images/common/ico_select_arrow_down.svg', width: 7.sp, height: 7.sp);
SvgPicture iconSortChecked = SvgPicture.asset('assets/images/common/ico_sort_checked.svg', width: 16.sp, height: 11.sp);
SvgPicture iconShopFilter = SvgPicture.asset('assets/images/common/ico_item_filter.svg', width: 18.sp, height: 16.sp);
SvgPicture iconShopFilterActive = SvgPicture.asset('assets/images/common/ico_item_filter_active.svg', width: 18.sp, height: 16.sp);
SvgPicture iconShopEmpty = SvgPicture.asset('assets/images/common/ico_shop_list_none.svg', width: 90.sp, height: 90.sp);
SvgPicture iconSkyBlueCheck = SvgPicture.asset('assets/images/common/ico_check_sky_blue.svg', width: 48.sp, height: 26.sp);

// Bottom Navigation Icon
SvgPicture iconMenuHome = SvgPicture.asset('assets/images/common/ico_menu_home.svg', width: 20.5.sp, height: 20.sp, color: lightGrayColor);
SvgPicture iconMenuHomeActive = SvgPicture.asset('assets/images/common/ico_menu_home.svg', width: 20.5.sp, height: 20.sp, color: skyBlueColor);
SvgPicture iconMenuArchive = SvgPicture.asset('assets/images/common/ico_menu_archive.svg', width: 27.sp, height: 17.sp, color: lightGrayColor);
SvgPicture iconMenuArchiveActive = SvgPicture.asset('assets/images/common/ico_menu_archive.svg', width: 27.sp, height: 17.sp, color: skyBlueColor);
SvgPicture iconMenuItems = SvgPicture.asset('assets/images/common/ico_menu_items.svg', width: 29.sp, height: 16.sp, color: lightGrayColor);
SvgPicture iconMenuItemsActive = SvgPicture.asset('assets/images/common/ico_menu_items.svg', width: 29.sp, height: 16.sp, color: skyBlueColor);
SvgPicture iconMenuRanking = SvgPicture.asset('assets/images/common/ico_menu_ranking.svg', width: 22.sp, height: 19.sp, color: lightGrayColor);
SvgPicture iconMenuRankingActive = SvgPicture.asset('assets/images/common/ico_menu_ranking.svg', width: 22.sp, height: 19.sp, color: skyBlueColor);
SvgPicture iconMenuShop = SvgPicture.asset('assets/images/common/ico_menu_shop.svg', width: 24.sp, height: 24.sp, color: lightGrayColor);
SvgPicture iconMenuShopActive = SvgPicture.asset('assets/images/common/ico_menu_shop.svg', width: 24.sp, height: 24.sp, color: skyBlueColor);

// Login
SvgPicture iconLoginApple = SvgPicture.asset('assets/images/login/ico_apple.svg', width: 11.sp, height: 14.sp);
SvgPicture iconLoginGoogle = SvgPicture.asset('assets/images/login/ico_google.svg', width: 14.sp, height: 14.sp);

// Header
SvgPicture iconHeaderLogo = SvgPicture.asset('assets/images/common/img_header_logo.svg', width: 90.sp, height: 20.sp);
SvgPicture iconHeaderAvatar = SvgPicture.asset('assets/images/common/ico_header_avatar.svg', width: 21.sp, height: 21.sp);
SvgPicture iconHeaderWallet = SvgPicture.asset('assets/images/common/ico_header_wallet.svg', width: 22.sp, height: 16.sp);

SvgPicture iconArchiveClock = SvgPicture.asset('assets/images/archive/ico_archive_clock.svg', width: 14.sp, height: 14.sp);
SvgPicture iconArchiveDistance = SvgPicture.asset('assets/images/archive/ico_archive_distance.svg', width: 14.sp, height: 14.sp);
SvgPicture iconArchiveSteps = SvgPicture.asset('assets/images/archive/ico_archive_steps.svg', width: 14.sp, height: 14.sp);

SvgPicture iconArchiveClockDetail = SvgPicture.asset('assets/images/archive/ico_archive_clock.svg', width: 20.sp, height: 20.sp);
SvgPicture iconArchiveDistanceDetail = SvgPicture.asset('assets/images/archive/ico_archive_distance.svg', width: 20.sp, height: 20.sp);
SvgPicture iconArchiveStepsDetail = SvgPicture.asset('assets/images/archive/ico_archive_steps.svg', width: 20.sp, height: 20.sp);

//activity
SvgPicture iconActivityTokenGo = SvgPicture.asset('assets/images/activity/ico_activity_token_go.svg', width: 41.84.sp, height: 43.sp);
SvgPicture iconActivityStoryWatch = SvgPicture.asset('assets/images/activity/ico_activity_story_watch.svg', width: 19.sp, height: 21.sp);
SvgPicture iconActivityStoryDistance = SvgPicture.asset('assets/images/activity/ico_activity_story_distance.svg', width: 14.5.sp, height: 13.44.sp);
SvgPicture iconActivityStorySteps = SvgPicture.asset('assets/images/activity/ico_activity_story_steps.svg', width: 21.74.sp, height: 24.sp);
SvgPicture iconActivityStoryTaika = SvgPicture.asset('assets/images/activity/ico_activity_story_tik.svg', width: 27.sp, height: 28.sp);
SvgPicture iconStamina = SvgPicture.asset('assets/images/activity/ico_stamina.svg', width: 12.sp, height: 18.sp);
SvgPicture iconShoes = SvgPicture.asset('assets/images/activity/ico_shoes.svg', width: 15.sp, height: 14.sp);
SvgPicture iconChallengeList = SvgPicture.asset('assets/images/activity/ico_challenge_list.svg', width: 70.sp, height: 70.sp);
SvgPicture iconChallengeFlag = SvgPicture.asset('assets/images/activity/ico_challenge_flag.svg', width: 58.sp, height: 55.sp);
SvgPicture iconCloseChallenge = SvgPicture.asset('assets/images/activity/ico_close.svg', width: 17.sp, height: 17.sp);
SvgPicture iconChallengeCheckOn = SvgPicture.asset('assets/images/activity/ico_challenge_checked.svg', width: 16.sp, height: 11.sp);
SvgPicture iconChallengeCheckOff = SvgPicture.asset('assets/images/activity/ico_challenge_unchecked.svg', width: 16.sp, height: 11.sp);
SvgPicture iconChallengeScreenBack = SvgPicture.asset('assets/images/activity/ico_challenge_screen_back.svg', width: 57.sp, height: 56.sp);
SvgPicture iconAppName = SvgPicture.asset('assets/images/activity/ico_app_name.svg', width: 140.sp, height: 32.sp);

// archive
SvgPicture iconArchiveDetailBadge = SvgPicture.asset('assets/images/archive/ico_archive_detail_badge.svg', width: 15.sp, height: 20.sp, color: Colors.black);
SvgPicture iconWasteBasket = SvgPicture.asset('assets/images/common/ico_wastebasket.svg', width: 15.sp, height: 20.sp);

//leaderboard
SvgPicture iconStatisticsTokenGo = SvgPicture.asset('assets/images/activity/ico_activity_token_go.svg', width: 25.27.sp, height: 27.62.sp);
SvgPicture iconCalendarStatisticsTokenTik = SvgPicture.asset('assets/images/leaderboard/ico_token_tik.svg', width: 17.54.sp, height: 19.18.sp);
SvgPicture iconLeaderboardRightArrow = SvgPicture.asset('assets/images/leaderboard/ico_right_arrow.svg');
SvgPicture iconMyRankArrow = SvgPicture.asset('assets/images/leaderboard/ico_my_rank_arrow.svg', width: 10.sp, height: 10.sp);
SvgPicture iconCalendar = SvgPicture.asset('assets/images/leaderboard/ico_calendar.svg', width: 18.95.sp, height: 18.85.sp);

SvgPicture iconArchiveWalking = SvgPicture.asset('assets/images/archive/ico_archive_walking.svg', width: 42.sp, height: 42.sp);
SvgPicture iconArchiveHiking = SvgPicture.asset('assets/images/archive/ico_archive_hiking.svg', width: 42.sp, height: 42.sp);

// inventory
SvgPicture iconGoReward = SvgPicture.asset('assets/images/inventory/ico_go_reward.svg', width: 20.sp, height: 16.sp);
SvgPicture iconItemAbrasion = SvgPicture.asset('assets/images/inventory/ico_item_abrasion.svg', width: 18.sp, height: 14.sp);
SvgPicture iconStaminaReduce = SvgPicture.asset('assets/images/inventory/ico_stamina_reduce.svg', width: 20.sp, height: 16.sp);
SvgPicture iconLucky = SvgPicture.asset('assets/images/inventory/ico_lucky.svg', width: 12.sp, height: 9.sp);
SvgPicture iconCirclePlus = SvgPicture.asset('assets/images/inventory/ico_circle_plus.svg', width: 37.sp, height: 37.sp);
SvgPicture iconNoBadge = SvgPicture.asset('assets/images/inventory/ico_no_badge.svg', width: 92.sp, height: 112.sp);

//mypage
SvgPicture iconCamera = SvgPicture.asset('assets/images/common/ico_camera.svg', width: 22.sp, height: 22.sp);
SvgPicture iconApple = SvgPicture.asset('assets/images/preference/ico_apple.svg', width: 12.sp, height: 14.sp);
SvgPicture iconGoogle = SvgPicture.asset('assets/images/preference/ico_google.svg', width: 14.sp, height: 14.sp);
SvgPicture iconAnswer = SvgPicture.asset('assets/images/preference/ico_answer.svg', width: 18.sp, height: 18.sp);
SvgPicture iconChevronDown = SvgPicture.asset('assets/images/preference/ico_chevron_down_grey.svg', width: 24.sp, height: 24.sp);
SvgPicture iconChevronUp = SvgPicture.asset('assets/images/preference/ico_chevron_up_color.svg', width: 24.sp, height: 24.sp);

//wallet
SvgPicture iconEmpty = SvgPicture.asset('assets/images/wallet/ico_empty.svg', width: 90.sp, height: 90.sp);
SvgPicture iconIn = SvgPicture.asset('assets/images/wallet/ico_in.svg', width: 20.sp, height: 20.sp);
SvgPicture iconOut = SvgPicture.asset('assets/images/wallet/ico_out.svg', width: 20.sp, height: 20.sp);
SvgPicture iconArrowRight = SvgPicture.asset('assets/images/wallet/ico_arrow_right.svg', width: 20.sp, height: 20.sp);
SvgPicture iconCoupon = SvgPicture.asset('assets/images/wallet/ico_coupon.svg', width: 38.sp, height: 38.sp);

//shop
SvgPicture iconShopStamina = SvgPicture.asset('assets/images/shop/ico_stat_stamina.svg', width: 14.sp, height: 14.sp, color: Colors.black);
SvgPicture iconShopDurability = SvgPicture.asset('assets/images/shop/ico_stat_durability.svg', width: 14.sp, height: 14.sp, color: Colors.black);
SvgPicture iconShopReward = SvgPicture.asset('assets/images/shop/ico_go_reward.svg', width: 14.sp, height: 14.sp, color: Colors.black);
SvgPicture iconUp = SvgPicture.asset('assets/images/wallet/ico_up.svg', width: 22.sp, height: 22.sp);

//grade
SvgPicture iconGradePoor = SvgPicture.asset('assets/images/common/ico_grade_poor.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeCommon = SvgPicture.asset('assets/images/common/ico_grade_common.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeUncommon = SvgPicture.asset('assets/images/common/ico_grade_uncommon.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeRare = SvgPicture.asset('assets/images/common/ico_grade_rare.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeEpic = SvgPicture.asset('assets/images/common/ico_grade_epic.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeLegend = SvgPicture.asset('assets/images/common/ico_grade_legend.svg', width: 90.sp, height: 24.sp);
SvgPicture iconGradeCirclePoor = SvgPicture.asset('assets/images/common/ico_grade_circle_poor.svg', width: 18.sp, height: 18.sp);
SvgPicture iconGradeCircleCommon = SvgPicture.asset('assets/images/common/ico_grade_circle_common.svg', width: 18.sp, height: 18.sp);
SvgPicture iconGradeCircleUncommon = SvgPicture.asset('assets/images/common/ico_grade_circle_uncommon.svg', width: 18.sp, height: 18.sp);
SvgPicture iconGradeCircleRare = SvgPicture.asset('assets/images/common/ico_grade_circle_rare.svg', width: 18.sp, height: 18.sp);
SvgPicture iconGradeCircleEpic = SvgPicture.asset('assets/images/common/ico_grade_circle_epic.svg', width: 18.sp, height: 18.sp);
SvgPicture iconGradeCircleLegend = SvgPicture.asset('assets/images/common/ico_grade_circle_legend.svg', width: 18.sp, height: 18.sp);
