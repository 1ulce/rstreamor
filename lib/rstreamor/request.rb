module Rstreamor
  class Request
    attr_accessor :request

    def initialize(request, file)
      self.request = request
      @@file = file
    end

    def ranges
      self.request.headers['HTTP_RANGE'].gsub('bytes=', '').split('-') if self.request.headers['HTTP_RANGE']
    end

    def upper_bound
      ranges[1] ? (ranges[1]).to_i : @@file.size
    end

    def lower_bound
      ranges[0] ? ranges[0].to_i : 0
    end

    def range_header?
      self.request.headers['HTTP_RANGE'].present?
    end

    def file_content_type
      "text/html"
    end

    def slice_file(file)
      if self.request.headers['HTTP_RANGE'].present?
        file.read[lower_bound, upper_bound]
      else
        file.read
      end
    end

    def file_size
      @@file.size
    end

  end
end