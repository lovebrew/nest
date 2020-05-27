local PATH = (...):gsub('%.init$', '')

require(PATH .. ".graphics")
require(PATH .. ".screen")

return {400, 480}
