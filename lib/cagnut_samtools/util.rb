module CagnutSamtools
  class Util
    attr_accessor :samtools, :config

    def initialize config=nil
      @config = config
      @samtools = CagnutSamtools::Base.new
    end

    def merge_bam dirs, previous_job_id, filename = nil
      samtools.merge_bam dirs, previous_job_id, filename
    end

    def mg_bam_soft_link dirs, previous_job_id, filename = nil
      samtools.mg_bam_soft_link dirs, previous_job_id, filename
    end

    def do_flag_stat dirs, previous_job_id, filename = nil
      samtools.do_flag_stat dirs, previous_job_id, filename
    end
  end
end
