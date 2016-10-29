module CagnutSamtools
  class Util
    attr_accessor :samtools, :config

    def initialize config=nil
      @config = config
      @samtools = CagnutSamtools::Base.new
    end

    def merge_bam dirs, order=1, previous_job_id=nil, filename = nil
      job_name, filename = samtools.merge_bam dirs, order, previous_job_id, filename
      [job_name, filename, order+1]
    end

    def mg_bam_soft_link dirs, order=1, previous_job_id=nil, filename = nil
      job_name, filename = samtools.mg_bam_soft_link dirs, order, previous_job_id, filename
      [job_name, filename, order+1]
    end

    def do_flag_stat dirs, order=1, previous_job_id=nil, filename = nil
      samtools.do_flag_stat dirs, order, previous_job_id, filename
      order+1
    end
  end
end
