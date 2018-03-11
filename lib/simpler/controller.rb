require_relative 'view'

module Simpler
  class Controller
    TEXT_HEADER = 'text/html'.freeze
    OK = '200'.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @logger = Logger.new(File.expand_path('log/app.log', __dir__))
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_status
      set_headers
      send(action)
      write_response
      @logger.info("Request: #{request.env['REQUEST_METHOD']} #{request.env['REQUEST_PATH']}\n
                    Handler: #{self.class.name}\##{action}\n
                    Parameters: #{params}\n
                    Response: #{@response.status} #{@response.header} #{@request.env['simpler.template']}\n")
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_status(status=OK)
      @response.status = status
    end

    def set_headers(header=TEXT_HEADER)
      @response['Content-Type'] = header
    end

    def write_response
      body = render_body
      @response.write(body)
    end

    def render_body
      unless @request.env['simpler.template'].key?(:plain)
        View.new(@request.env).render(binding)
      else
        @request.env['simpler.template'][:plain]
      end
    end

    def params
      @request.env[:params]
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
