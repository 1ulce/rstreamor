module Rstreamor
  class Response
    attr_accessor :request

    def initialize(request)
      self.request = request
    end

    def response_code
      self.request.range_header? ? 206 : 200
    end

    def content_length(file)
      if self.request.range_header?
        (self.request.upper_bound - self.request.lower_bound + 1).to_s
      else
        file.size.to_s
      end
    end

    def content_range(file)
      "bytes #{self.request.lower_bound}-#{self.request.upper_bound}/#{file.size}"
    end

    def accept_ranges
      'bytes'
    end

    def cache_control
      'no-cache'
    end

  end
end