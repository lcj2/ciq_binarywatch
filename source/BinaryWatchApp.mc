//! =====================================================================
//! Project   : BinaryWatch
//! File      : BinaryWatchApp.mc
//! Author    : lcj2
//!
//! Copyright (c) 2022, lcj2.
//! All rights reserved.
//!
//! Redistribution and use in source and binary forms, with or without
//! modification, are permitted provided that the following conditions
//! are met:
//!
//!     * Redistributions of source code must retain the above copyright
//!       notice, this list of conditions and the following disclaimer.
//!     * Redistributions in binary form must reproduce the above
//!       copyright notice, this list of conditions and the following
//!       disclaimer in the documentation and/or other materials
//!       provided with the distribution.
//!     * Neither the name of the author nor the names of its
//!       contributors may be used to endorse or promote products
//!       derived from this software without specific prior written
//!       permission.
//!
//! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//! "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//! LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//! FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
//! COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//! INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//! BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//! CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//! LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
//! ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//! POSSIBILITY OF SUCH DAMAGE.
//! =====================================================================

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var partialUpdatesAllowed as Boolean = false;

class BinaryWatchApp extends Application.AppBase {

    private var _mAppVersion as String = "1.5.0";
    private var _mBWView as BinaryWatchView?;

    function initialize() {
        AppBase.initialize();
        Properties.setValue("APP_VERSION", _mAppVersion);
        $.partialUpdatesAllowed = (Toybox.WatchUi.WatchFace has :onPartialUpdate);
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! onSettingsChanged() is called when user settings are changed
    function onSettingsChanged() as Void {
        if (_mBWView instanceof BinaryWatchView) {
            _mBWView.updateUserSettings();
        }
        WatchUi.requestUpdate();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates> or Null {
        _mBWView = new BinaryWatchView();
        if ($.partialUpdatesAllowed) {
            return [ _mBWView, new BinaryWatchDelegate() ] as Array<Views or InputDelegates>;
        } else {
            return [ _mBWView ] as Array<Views or InputDelegates>;
        }
    }

}

function getApp() as BinaryWatchApp {
    return Application.getApp() as BinaryWatchApp;
}
