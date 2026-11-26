# Floorp's design settings, written whole: Floorp rebuilds its userChrome.* prefs
# from this at startup, so setting those prefs alone does not stick.
{
  globalConfigs = {
    appliedUserJs = "";
    faviconColor = false;
    userInterface = "lepton";
  };
  tab = {
    tabDoubleClickToClose = false;
    tabMinHeight = 30;
    tabMinWidth = 76;
    tabOpenPosition = -1;
    tabPinTitle = false;
    tabScroll = {
      enabled = false;
      reverse = false;
      wrap = false;
    };
  };
  tabbar = {
    multiRowTabBar = {
      maxRow = 3;
      maxRowEnabled = false;
    };
    tabbarPosition = "default";
    tabbarStyle = "horizontal";
  };
  uiCustomization = {
    bookmarkBar = {
      focusExpand = false;
      position = "top";
    };
    chromeExtras = {
      autohideBackButton = false;
      autohideForwardButton = false;
      autohideNavbar = false;
      autohidePageAction = false;
      autohideSidebar = false;
      autohideTab = false;
      centeredBookmarkbar = false;
      centeredTab = false;
      centeredUrlbar = false;
      hiddenBookmarkbarIcon = false;
      hiddenBookmarkbarLabel = false;
      hiddenDisabledMenu = false;
      hiddenNavbar = false;
      hiddenSidebarHeader = false;
      hiddenTabAttentionIndicator = false;
      hiddenTabAudioIndicator = false;
      hiddenTabCloseButton = false;
      hiddenTabIcon = false;
      hiddenTabNoteIcon = false;
      hiddenTabSharingIndicator = false;
      hiddenTabbar = true; # Sidebery lists the tabs
      hiddenUrlbarIconbox = false;
      iconDisabled = false;
      iconMenu = true;
      sidebarOverlap = false;
      tabbarAsTitlebar = false;
      tabbarOneLiner = false;
      urlViewAlwaysShowPageActions = false;
      urlViewGoButtonWhenTyping = false;
      urlViewMoveIconToLeft = false;
    };
    display = {
      deleteBrowserBorder = false;
      disableFullscreenNotification = false;
    };
    multirowTab = {newtabInsideEnabled = false;};
    navbar = {
      position = "top";
      searchBarTop = false;
    };
    qrCode = {disableButton = false;};
    special = {
      hideForwardBackwardButton = false;
      optimizeForTreeStyleTab = false;
      stgLikeWorkspaces = false;
    };
  };
}
