//! =====================================================================
//! Project   : BinaryWatch
//! File      : BinaryWatchView.mc
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
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

class BinaryWatchView extends WatchUi.WatchFace {

    // user settings/properties
    private var _mPropBackgroundColor as ColorType?;
    private var _mPropGridHoursColor as ColorType?;
    private var _mPropGridMinutesColor as ColorType?;
    private var _mPropGridSecondsColor as ColorType?;
    private var _mPropGridOffColor as ColorType?;

    // instance variables
    private var _mLowPower as Boolean = false;
    private var _mX as Number = 0;
    private var _mY as Number = 0;
    private var _mXY as Number = 0;
    private var _mXYOffset as Number = 0;

    function initialize() {
        WatchFace.initialize();
        self.updateUserSettings();
    }

    //! Update user settings
    function updateUserSettings() as Void {
        _mPropBackgroundColor = (Properties.getValue("PROP_BACKGROUND_COLOR") == null) ? 0 : (Properties.getValue("PROP_BACKGROUND_COLOR") as String).toNumber();
        _mPropGridHoursColor = (Properties.getValue("PROP_GRID_HOURS") == null) ? 65280 : (Properties.getValue("PROP_GRID_HOURS") as String).toNumber();
        _mPropGridMinutesColor = (Properties.getValue("PROP_GRID_MINUTES") == null) ? 16733440 : (Properties.getValue("PROP_GRID_MINUTES") as String).toNumber();
        _mPropGridSecondsColor = (Properties.getValue("PROP_GRID_SECONDS") == null) ? 43775 : (Properties.getValue("PROP_GRID_SECONDS") as String).toNumber();
        _mPropGridOffColor = (Properties.getValue("PROP_GRID_OFF") == null) ? 11184810 : (Properties.getValue("PROP_GRID_OFF") as String).toNumber();
    }

    //! Load your resources here
    function onLayout(dc as Dc) as Void {
        // determine plot points
        _mX = Math.round(dc.getWidth() * 0.2).toNumber();
        _mXY = Math.round(((dc.getWidth() - (_mX * 2)) - 30) / 6).toNumber();
        _mXYOffset = _mXY + 6;
        _mY = (dc.getHeight() / 2) + _mXY + 9;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() as Void {
    }

    //! Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var binaryTime = new[4];
        binaryTime[0] = self.decToBin((clockTime.hour / 10) % 10);
        binaryTime[1] = self.decToBin(clockTime.hour % 10);
        binaryTime[2] = self.decToBin((clockTime.min / 10) % 10);
        binaryTime[3] = self.decToBin(clockTime.min % 10);

        // clear clips
        if ($.partialUpdatesAllowed) {
            dc.clearClip();
        }

        // determine background color and clear screen
        var bgColor = _mPropBackgroundColor;
        var fgColor = (bgColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_TRANSPARENT, bgColor);
        dc.clear();

        var x = (_mLowPower && !$.partialUpdatesAllowed) ? _mX + _mXYOffset : _mX;
        var y = _mY;
        for (var i = 0; i < 4; i++) {
            for (var j = 0; j < (binaryTime[i] as Array<Number>).size(); j++ ) {
                if (i == 0 || i == 1) {
                    dc.setColor(((binaryTime[i] as Array<Number>)[j] as Number == 1) ? _mPropGridHoursColor : _mPropGridOffColor, Graphics.COLOR_TRANSPARENT);
                } else if (i == 2 || i == 3) {
                    dc.setColor(((binaryTime[i] as Array<Number>)[j] as Number == 1) ? _mPropGridMinutesColor : _mPropGridOffColor, Graphics.COLOR_TRANSPARENT);
                } else {
                    dc.setColor(_mPropGridOffColor, Graphics.COLOR_TRANSPARENT);
                }
                if (!(i == 0 && (j == 2 || j == 3)) &&
                    !(i == 2 && j == 3)) {
                    dc.fillRectangle(x, y - (j * _mXYOffset), _mXY, _mXY);
                }
            }
            x = x + (_mXYOffset as Number);
        }

        // draw the seconds in onPartialUpdate(dc)
        if (!_mLowPower || $.partialUpdatesAllowed) {
            self.onPartialUpdate(dc);
        }
    }

    //! Handle the partial update event
    function onPartialUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var binaryTime = new[4];
        binaryTime[0] = self.decToBin((clockTime.sec / 10) % 10);
        binaryTime[1] = self.decToBin(clockTime.sec % 10);

        // update clipping region for seconds
        if ($.partialUpdatesAllowed) {
            dc.setClip(_mX + (_mXYOffset * 4), _mY - (3 * _mXYOffset), 2 * _mXYOffset, 4 * _mXYOffset);
        }

        // draw the seconds
        var x = _mX + (_mXYOffset * 4);
        var y = _mY;
        for (var i = 0; i < 2; i++) {
            for (var j = 0; j < (binaryTime[i] as Array<Number>).size(); j++ ) {
                dc.setColor(((binaryTime[i] as Array<Number>)[j] as Number == 1) ? _mPropGridSecondsColor : _mPropGridOffColor, Graphics.COLOR_TRANSPARENT);
                if (!(i == 0 && j == 3)) {
                    dc.fillRectangle(x, y - (j * _mXYOffset), _mXY, _mXY);
                }
            }
            x = x + _mXYOffset;
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() as Void {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        _mLowPower = false;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        _mLowPower = true;
        WatchUi.requestUpdate();
    }

    //! Calculate the binary version of decimal value
    function decToBin(dec as Number) as Array<Number> {
        var bin = [0, 0, 0, 0] as Array<Number>;
        var i = 0;
        while (dec) {
            bin[i] = dec % 2;
            dec = dec / 2;
            i++;
        }
        return bin;
    }
}
