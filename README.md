# [Chronosphere](https://chronosphere.io/) [Chromium](https://www.chromium.org/chromium-projects/) container image for [Instruqt](https://instruqt.com/)

A bespoke Chromium docker image, built on top of [KASM](https://www.kasmweb.com/) images.

Built for use in Instruqt labs, for Chronosphere.

Requires ENV variables to be set;
- LAUNCH_URL - tenant URL to browse to, normally https://university.chronosphere.io

- AUTOLOGIN - 0/1, whether to enable autoLogin extension
- AUTOLOGIN_EMAIL - tenant username
- AUTOLOGIN_PASSWORD - tenant password

- REMOVEADMINMENU - 0/1, whether to enable removeNavMenuAdmin extension

Chrome policy files allow/block following URLs;
Allow
- `https://university.chronosphere.io`
- `https://chronosphereio.okta.com`
- `chrome-extension://*`
Block
- `file://` 

Credits;
- KASM tech [chromium image](https://github.com/kasmtech/workspaces-images)
- Modifications by [The Monitoring Shop](https://themonitoringshop.com/)
