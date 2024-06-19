class TrackingCodeGenerator
  class << self
    def call(code_length = 4)
      loop do
        code = SecureRandom.hex(code_length)
        return code unless unavailable_codes.include?(code)
      end
    end

    private

    def unavailable_codes
      @unavailable_codes ||= Set.new(TrackingLink.pluck(:tracking_code))
    end
  end
end
