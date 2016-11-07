require "cagnut_samtools/version"

module CagnutSamtools
  class << self
    def config
      @config ||= begin
        CagnutSamtools::Configuration.load(Cagnut::Configuration.config, Cagnut::Configuration.params['samtools'])
        CagnutSamtools::Configuration.instance
      end
    end
  end
end

require 'cagnut_samtools/configuration'
require 'cagnut_samtools/check_tools'
require 'cagnut_samtools/base'
require 'cagnut_samtools/util'
