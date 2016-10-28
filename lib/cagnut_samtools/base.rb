require 'cagnut_samtools/functions/merge_bam'
require 'cagnut_samtools/functions/mg_bam_soft_link'
require 'cagnut_samtools/functions/do_flag_stat'

module CagnutSamtools
  class Base

    def merge_bam dirs, previous_job_id, input = nil
      opts = { input: input, dirs: dirs }
      CagnutSamtools::MergeBam.new(opts).run previous_job_id
    end

    def mg_bam_soft_link dirs, previous_job_id, input = nil
      opts = { input: input, dirs: dirs }
      CagnutSamtools::MgBamSoftLink.new(opts).run previous_job_id
    end

    def do_flag_stat dirs, previous_job_id, input = nil
      opts = { input: input, dirs: dirs }
      CagnutSamtools::DoFlagStat.new(opts).run previous_job_id
    end
  end
end
