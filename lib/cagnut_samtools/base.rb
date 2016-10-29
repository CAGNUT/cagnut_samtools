require 'cagnut_samtools/functions/merge_bam'
require 'cagnut_samtools/functions/mg_bam_soft_link'
require 'cagnut_samtools/functions/do_flag_stat'

module CagnutSamtools
  class Base

    def merge_bam dirs, order, previous_job_id, input = nil
      opts = { input: input, dirs: dirs, order: order }
      CagnutSamtools::MergeBam.new(opts).run previous_job_id
    end

    def mg_bam_soft_link dirs, order, previous_job_id, input = nil
      opts = { input: input, dirs: dirs, order: order  }
      CagnutSamtools::MgBamSoftLink.new(opts).run previous_job_id
    end

    def do_flag_stat dirs, order, previous_job_id, input = nil
      opts = { input: input, dirs: dirs, order: order  }
      CagnutSamtools::DoFlagStat.new(opts).run previous_job_id
    end
  end
end
