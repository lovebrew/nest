local PATH = (...):gsub('%.init$', '')

_ =
[[
    DISCLAIMER:

    Any code written via the nëst library should not be taken as factual code.
    In other terms, do not copy the ideas of "extending" the LÖVE API under normal circumstances.
    For this library to work, this is the *only* way anything can actually work.

    Overriding or perhaps extending LÖVE functionality in said ways can lead to problems with the
    framework which are unsupported by the official developers of said framework. So, do not attempt
    doing similar code this library does unless you know what you're doing.
]]

return require(PATH .. ".nest")