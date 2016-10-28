require 'singleton'

module CagnutSamtools
  class Configuration

    include Singleton
    attr_accessor :samtools_path
    attr_reader :config

    class << self
      def load config, params
        instance.load config, params
      end
    end

    def load config, params = nil
      @config = config
      attributes.each do |name, value|
        send "#{name}=", value if respond_to? "#{name}="
      end
    end

    def attributes
      {
        samtools_path: @config['tools']['samtools']
      }
    end
  end
end
