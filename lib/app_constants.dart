class AppConstants {
  // URL 링크
  static const String baseUrl = 'http://210.121.223.5:11101/';
  static const String treatmentUrl = 'http://210.121.223.5:11101/Demo/Pages/Treatment/BaseAuth.html';

  // 채팅봇 링크 url
  static const String aiChatUrl =
      'https://exona.kr/aichat/aichat_sjh01.html?tenantid=sjh01&tenantname=%EC%9D%B8%EC%B2%9C%EC%84%B8%EC%A2%85%EB%B3%91%EC%9B%90';

  // 네비게이션 바 항목 관련 url
  static const String homeScreenUrl =
      'http://210.121.223.5:11101/Demo/Pages/Register/BaseAuth.html'; //홈버튼 웹뷰
  static const String treatmentReservationScreenUrl =
      "http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_app_reservation_1.html"; // 진료예약 버튼 웹뷰


  static const String loginUrl = 'http://210.121.223.5:11101/Demo/Pages/Login/BaseAuth.html';
  static const userAvatarImageUrl = 'https://via.placeholder.com/150';


  // 앱 제목
  static const String appTitle = 'VisualAgent';

  // 내비게이션 및 탭에 사용될 텍스트
  static const String home = '홈';
  static const String menu = '메뉴';
  static const String treatment = '진료예약';
  static const String userInfo = '내 정보';

  // 로그인 스크린 관련 텍스트
  static const String emailLabel = '이메일';
  static const String passwordLabel = '비밀번호';
  static const String loginButton = '로그인';

  // 사용자 정보 스크린 관련 텍스트
  static const String accountInfoTitle = '계정 정보';
  static const String editProfileButton = '프로필 편집';
  static const String logout = '로그아웃';
  static const String login = '로그인';
  static const String register = '회원가입';
  static const String logoutConfirmationButton = '정말로 로그아웃 하시겠습니까?';
  static const String userName = '홍길동'; //사용자 이름 예시

  // 즐겨찾기 목록 관련 텍스트
  static const String favoritesTitle = '즐겨찾기 목록';
  static const String addFavorite = '즐겨찾기 추가';
  static const String removeFavorite = '즐겨찾기 제거';
  static const String noFavorites = '추가하신 즐겨찾기가 없습니다.';

  // 웹뷰 스크린 제목
  static const String webViewTitle = '웹페이지 보기';

  // 앱바 내 검색 텍스트
  static const String searchHint = '검색하기';

  // 알람 관련 텍스트
  static const String alarmTitle = '알람';


  // 플로팅 버튼 말풍선 반복 메세지
  static const String speechBubbleMessage = '안녕하세요! 무엇을 도와드릴까요?😊';

  // (웹뷰) 화면 전환 대기중 메세지
  static const String pleaseWait = '잠시만 기다려주세요...';



  //네비게이션 바 메뉴 목록 텍스트 & url
  static const String menuText1 = '진료/검사 예약';
  static const String menuUrl1 = 'http://210.121.223.5:11101/Main?PatientType=N';
  static const String menuText2 = '진료상담/병원안내';
  static const String menuUrl2 = 'http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_app.html';
  static const String menuText3 = '건강검진 예약';
  static const String menuUrl3 = 'http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_app_reservation_1.html';
  static const String menuText4 = '증명서 발급';
  static const String menuUrl4 = 'https://clinic.mycerti.com/';

  // 기타 기본 텍스트
  static const String close = '닫기';
  static const String ok = '확인';
  static const String cancel = '취소';
  static const String save = '저장';

  //설정 화면 텍스트
  static const String settings = '설정';
  static const String darkMode = '다크 모드';
  static const String favorites = '즐겨찾기';
  static const String alarmManagement = '알람 관리';
  static const String customerCenter = '고객센터';

  static const String deviceAccess = '기기 설정 권한';
  static const String phone = '1599-2745';
  static const String privacyPolicy = '개인정보처리방침';
  static const String phoneCallFailMessage = '전화 연결을 할 수 없습니다.';


}
