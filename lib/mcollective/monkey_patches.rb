# a method # that walks an array in groups, pass a block to
# call the block on each sub array
class Array
  unless method_defined?(:in_groups_of)
    def in_groups_of(chunk_size, padded_with=nil, &block)
      arr = clone

      # how many to add
      padding = chunk_size - (arr.size % chunk_size)

      # pad at the end
      arr.concat([padded_with] * padding) unless padding == chunk_size

      # how many chunks we'll make
      count = arr.size / chunk_size

      # make that many arrays
      result = []
      count.times {|s| result << arr[s * chunk_size, chunk_size]}

      if block_given?
        result.each_with_index do |a, i|
          case block.arity
          when 1
            yield(a)
          when 2
            yield(a, (i == result.size - 1))
          else
            raise "Expected 1 or 2 arguments, got #{block.arity}"
          end
        end
      else
        result
      end
    end
  end
end

# Reject all SSLv2 ciphers and all SSLv2 or SSLv3 handshakes by default.
# The openssl gem freezes DEFAULT_PARAMS from 4.0 on, so the adjusted
# defaults are passed to set_params on each new context instead of being
# written into the shared hash.
require "openssl"
class OpenSSL::SSL::SSLContext # rubocop:disable Style/ClassAndModuleChildren
  alias __mcollective_original_initialize initialize
  private :__mcollective_original_initialize

  def initialize(*args)
    __mcollective_original_initialize(*args)

    options = DEFAULT_PARAMS[:options] | OpenSSL::SSL::OP_NO_SSLv2 | OpenSSL::SSL::OP_NO_SSLv3 | OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS

    params = {:options => options}
    params[:ciphers] = "#{DEFAULT_PARAMS[:ciphers]}:!SSLv2" if DEFAULT_PARAMS[:ciphers]

    set_params(params)
  end
end
