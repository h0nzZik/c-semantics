require "alignment.k"
require "bits.k"
require "builtin.k"
require "compat.k"
require "configuration.k"
require "error.k"
require "function-call.k"
require "init.k"
require "memory.k"
require "resolution.k"
require "settings.k"
require "symloc.k"
require "syntax.k"
require "return.k"

module COMMON
  imports ALIGNMENT
  imports BITS
  imports COMMON-BUILTIN
  imports COMMON-RESOLUTION
  imports COMPAT
  imports ERROR
  imports COMMON-INIT
  imports MEMORY
  imports SYMLOC
endmodule
