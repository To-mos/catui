--[[
The MIT License (MIT)

Copyright (c) 2016 WilhanTian  田伟汉, 2017 Thomas Wills

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local thisDir = ... .. '.'

utf8  = require 'utf8'
class = require( thisDir .. 'libs.30log' )

require( thisDir .. 'Core.UIConst' )

UITheme       = require( thisDir .. 'UITheme' )
UIUtils       = require( thisDir .. 'Utils.Utils' )
Rect          = require( thisDir .. 'Core.Rect' )

UIEvent       = require( thisDir .. 'Core.UIEvent' )
UIControl     = require( thisDir .. 'Core.UIControl' )
UIRoot        = require( thisDir .. 'Core.UIRoot' )
UIManager     = require( thisDir .. 'Core.UIManager' )
-- UIList        = require( thisDir .. 'Control.UIList' )
UILabel       = require( thisDir .. 'Control.UILabel' )
UIButton      = require( thisDir .. 'Control.UIButton' )
UIImage       = require( thisDir .. 'Control.UIImage' )
UIScrollBar   = require( thisDir .. 'Control.UIScrollBar' )
UIContent     = require( thisDir .. 'Control.UIContent' )
UICheckBox    = require( thisDir .. 'Control.UICheckBox' )
UIProgressBar = require( thisDir .. 'Control.UIProgressBar' )
UIEditText    = require( thisDir .. 'Control.UIEditText' )
