import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/term_item_model.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class WithdrawConfirmController extends GetxController {
  final RxList<TermItemModel> withdrawCheckList = RxList.empty();
  final RxBool allAgreed = RxBool(false);

  @override
  void onInit() {
    getWithdrawCheckList();
    super.onInit();
  }

  void getWithdrawCheckList() {
    withdrawCheckList.value = [
      TermItemModel(
        title: '정산되지 않은 GO는 소멸됩니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '모든 운동 기록과 개인 정보는 삭제됩니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '코인, 지갑, 거래 내역 등을 복구할 수 없습니다.',
        isChecked: false,
      ),
      TermItemModel(
        title: '외부 지갑으로 전송하지 않은 뱃지 NFT와 신발, 모자, 옷 등의 아이템은 소멸됩니다.',
        isChecked: false,
      ),
    ];
  }

  void toggleCheckList(TermItemModel termItem) {
    List<TermItemModel> withdrawCheckList = this.withdrawCheckList;
    this.withdrawCheckList.value = withdrawCheckList.map((term) {
      if (term == termItem) {
        term.isChecked = !termItem.isChecked;
      }
      return term;
    }).toList();
    allAgreed.value = withdrawCheckList.every((term) => term.isChecked);
  }

  void toggleAllTerms() {
    List<TermItemModel> withdrawCheckList = this.withdrawCheckList;
    this.withdrawCheckList.value = withdrawCheckList.map((term) {
      term.isChecked = !allAgreed.value;
      return term;
    }).toList();
    allAgreed.value = !allAgreed.value;
  }

  void showWithdrawConfirmPopup() {
    Get.bottomSheet(
      Container(
        height: 230,
        decoration: const BoxDecoration(
          color: Color(0xff363841),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: StyledText(
                    '탈퇴에 최종 동의 하십니까?',
                    fontSize: 22,
                    lineHeight: 24,
                    fontWeight: 500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: StyledText(
                    '아쉽네요.\n다음에 다시 가자고와 만나요!',
                    fontSize: 16,
                    lineHeight: 22,
                    fontWeight: 500,
                    textAlign: TextAlign.center,
                    color: Color(0xFFBFBFBF),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF363841),
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: StyledText(
                                '취소',
                                fontSize: 18,
                                lineHeight: 18,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EE6F3),
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Get.toNamed(Routes.withdrawCompleted),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                                child: StyledText(
                              '확인',
                              fontSize: 18,
                              lineHeight: 18,
                              color: Colors.black,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
