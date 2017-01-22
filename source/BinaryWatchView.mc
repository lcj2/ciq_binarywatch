//! =====================================================================
//! Project   : BinaryWatch
//! File      : BinaryWatchView.mc
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
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class BinaryWatchView extends Ui.WatchFace {

    // user settings/properties
    hidden var _mPropBackgroundColor;
    hidden var _mPropGridOnColor;
    hidden var _mPropGridOffColor;

    // instance variables
    hidden var _mLowPower = false;
    hidden var _mX;
    hidden var _mY;
    hidden var _mXY;
    hidden var _mXYOffset;

    function initialize() {
        WatchFace.initialize();
        self.updateUserSettings();
    }

    //! Update user settings
    function updateUserSettings() {
        var app = App.getApp();
        _mPropBackgroundColor = (app.getProperty("PROP_BACKGROUND_COLOR") == null) ? 0 : app.getProperty("PROP_BACKGROUND_COLOR").toNumber();
        _mPropGridOnColor = (app.getProperty("PROP_GRID_ON") == null) ? 16733440 : app.getProperty("PROP_GRID_ON").toNumber();
        _mPropGridOffColor = (app.getProperty("PROP_GRID_OFF") == null) ? 11184810 : app.getProperty("PROP_GRID_OFF").toNumber();
    }

    //! Load your resources here
    function onLayout(dc) {
        // determine plot points
        _mX = Math.round(dc.getWidth() * 0.2);
        _mXY = Math.round(((dc.getWidth() - (_mX * 2)) - 30) / 6);
        _mXYOffset = _mXY + 6;
        _mY = (dc.getHeight() / 2) + _mXY + 9;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var clockTime = Sys.getClockTime();
        var binaryTime = new[6];
        binaryTime[0] = self.decToBin((clockTime.hour / 10) % 10);
        binaryTime[1] = self.decToBin(clockTime.hour % 10);
        binaryTime[2] = self.decToBin((clockTime.min / 10) % 10);
        binaryTime[3] = self.decToBin(clockTime.min % 10);
        binaryTime[4] = self.decToBin((clockTime.sec / 10) % 10);
        binaryTime[5] = self.decToBin(clockTime.sec % 10);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // determine background color and clear screen
        var bgColor = _mPropBackgroundColor;
        var fgColor = (bgColor == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
        dc.setColor(Gfx.COLOR_TRANSPARENT, bgColor);
        dc.clear();

        var x = (_mLowPower) ? _mX + _mXYOffset : _mX;
        var y = _mY;
        var timeColumns = (_mLowPower) ? binaryTime.size() - 2 : binaryTime.size();
        for (var i = 0; i < timeColumns; i++) {
            for (var j = 0; j < binaryTime[i].size(); j++ ) {
                if (!(i == 0 && (j == 2 || j == 3)) &&
                    !(i == 2 && j == 3) &&
                    !(i == 4 && j == 3)) {
                    dc.setColor((binaryTime[i][j] == 1) ? _mPropGridOnColor : _mPropGridOffColor, Gfx.COLOR_TRANSPARENT);
                    dc.fillRectangle(x, y - (j * _mXYOffset), _mXY, _mXY);
                }
            }
            x = x + _mXYOffset;
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        _mLowPower = false;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        _mLowPower = true;
        Ui.requestUpdate();
    }

    //! Calculate the binary version of decimal value
    function decToBin(dec) {
        var bin = [0, 0, 0, 0];
        var i = 0;
        while (dec) {
            bin[i] = dec % 2;
            dec = dec / 2;
            i++;
        }
        return bin;
    }
}
