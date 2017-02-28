module Rstreamor
  module Stream
    def stream(file)
      request_builder = Rstreamor::Request.new(request, file)
      response_builder = Rstreamor::Response.new(request_builder)
      set_response_header(request_builder, response_builder, file)
      stream_file(request_builder, response_builder, file)
    end

    private

    def stream_file(request_builder, response_builder, file)
      content = request_builder.slice_file(file)
      send_data content, type: request_builder.file_content_type, disposition: 'inline', status: response_builder.response_code
    end

    def set_response_header(request_builder, response_builder, file)
      response.headers['Content-Type'] = request_builder.file_content_type
      length = response_builder.content_length(file)
      response.headers['Content-Length'] = length
      if request_builder.range_header?
        response.headers['Accept-Ranges'] = 'bytes'
        response.headers['Cache-Control'] = 'no-cache'
        response.headers['Content-Range'] = response_builder.content_range(file)
      else
        response.headers['Accept-Ranges'] = 'bytes'
        response.headers['Cache-Control'] = 'no-cache'
        response.headers['Content-Range'] = "bytes 0-#{length.to_i - 1}/#{length}"
      end
    end
  end
end