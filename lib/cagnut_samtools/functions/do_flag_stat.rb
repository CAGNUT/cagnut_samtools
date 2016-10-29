module CagnutSamtools
  class DoFlagStat
    extend Forwardable

    def_delegators :'Cagnut::Configuration.base', :jobs_dir, :sample_name,
                   :ref_fasta, :prefix_name, :dodebug
    def_delegators :'CagnutSamtools.config', :samtools_path

    def initialize opts = {}
      @order = sprintf '%02i', opts[:order]
      @job_name = "#{prefix_name}_doFlagStat_#{sample_name}"
      @input = opts[:input].nil? ? "#{opts[:dirs][:input]}/#{sample_name}_markdup.bam" : opts[:input]
      @output = "#{opts[:dirs][:output]}/#{sample_name}_merged_markdup.flagstat"
    end

    def run previous_job_id = nil
      puts "Submitting doFlagStat for #{sample_name}_markdup suffix"
      script_name = generate_script
      ::Cagnut::JobManage.submit script_name, @job_name, queuing_options(previous_job_id)
      @job_name
    end

    def queuing_options previous_job_id = nil
      {
        previous_job_id: previous_job_id,
        adjust_memory: ['h_vmem=500M'],
        tools: ['samtools', 'do_flag_stat']
      }
    end

    def generate_script
      script_name = "#{@order}_samtools_do_flag_stat"
      file = File.join jobs_dir, "#{script_name}.sh"
      File.open(file, 'w') do |f|
        f.puts <<-BASH.strip_heredoc
          #!/bin/bash
          echo "#{script_name} is starting at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"
          #{samtools_path} flagstat #{@input} > #{@output} \\
            #{::Cagnut::JobManage.run_local}

          if [ ! -s #{@output} ]
          then
            echo "Incomplete output file #{@output}"
            exit 100
          fi
          echo "#{script_name} is finished at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"

        BASH
      end
      File.chmod(0700, file)
      script_name
    end
  end
end
