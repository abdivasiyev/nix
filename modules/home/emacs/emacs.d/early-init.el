(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq package-enable-at-startup nil)

(setq ns-use-native-fullscreen :true)
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))