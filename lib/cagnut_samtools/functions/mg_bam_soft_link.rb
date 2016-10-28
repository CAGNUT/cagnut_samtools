module CagnutSamtools
  class MgBamSoftLink
    extend Forwardable

    def_delegators :'Cagnut::Configuration.base', :jobs_dir, :prefix_name, :dodebug,
                   :magic28, :ref_fasta, :sample_name
    def_delegators :'CagnutSamtools.config', :samtools_path

    def initialize opts = {}
      @job_name = "#{prefix_name}_mgBam_#{sample_name}"
      @input = opts[:input].nil? ? "#{opts[:dirs][:input]}/#{sample_name}_rg.bam" : opts[:input]
      @output = "#{opts[:dirs][:output]}/#{sample_name}_merged.bam"
      @output_bai = "#{opts[:dirs][:output]}/#{sample_name}_merged.bai"
    end

    def run previous_job_id = nil
      puts "Submitting mgBamSoftLink #{@input}"
      script_name = generate_script
      ::Cagnut::JobManage.submit  script_name, @job_name, queuing_options(previous_job_id)
      [@job_name, @output]
    end

    def queuing_options previous_job_id = nil
      {
        previous_job_id: previous_job_id,
        tools: ['samtools', 'mg_bam_soft_link']
      }
    end

    def generate_script
      script_name = 'samtools_mg_bam_soft_link'
      file = File.join jobs_dir, "#{script_name}.sh"
      File.open(file, 'w') do |f|
        f.puts <<-BASH.strip_heredoc
          #!/bin/bash

          cd "#{jobs_dir}/../"
          echo "#{script_name} is starting at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"
          rm -f #{@output} #{@output_bai}
          ln -s #{@input}  #{@output}

          # Check BAM EOF
          BAM_28=$(tail -c 28 #{@output}|xxd -p)
          if [ "#{magic28}" != "$BAM_28" ]
          then
            echo "Error with BAM EOF" 1>&2
            exit 100
          fi

          #{samtools_path} index #{@output} \\
            #{::Cagnut::JobManage.run_local}
          mv #{output}.bai #{@output_bai}

          if [ !  -s "#{@output_bai}" ]
          then
            echo "Incorrect Output!"
            exit 100
          fi
          echo "#{script_name} is finished at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"

          exit $EXITSTATUS
        BASH
      end
      File.chmod(0700, file)
      script_name
    end
  end
end
