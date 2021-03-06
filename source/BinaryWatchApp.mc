//! =====================================================================
//! Project   : BinaryWatch
//! File      : BinaryWatchApp.mc
//! Author    : lcj2
//!
//! Copyright (c) 2017, lcj2.
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

using Toybox.Application as App;
using Toybox.WatchUi as Ui;

var APP_VERSION = "1.0.0";

class BinaryWatchApp extends App.AppBase {

    hidden var _mBWView;

    function initialize() {
        AppBase.initialize();
        App.getApp().setProperty("APP_VERSION", $.APP_VERSION);
    }

    //! onStart() is called on application start up
    function onStart(state) {
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! onSettingsChanged() is called when user settings are changed
    function onSettingsChanged() {
        _mBWView.updateUserSettings();
        Ui.requestUpdate();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        _mBWView = new BinaryWatchView();
        return [ _mBWView ];
    }

}
