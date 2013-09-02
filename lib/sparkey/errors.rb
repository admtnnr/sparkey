class Sparkey::Error < StandardError; end

module Sparkey::Errors
  def handle_status(status)
    if status != :success
      error_message = Sparkey::Native.error_string(status)

      raise Sparkey::Error, error_message
    end
  end
end
