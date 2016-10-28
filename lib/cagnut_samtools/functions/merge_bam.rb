module CagnutSamtools
  class MergeBam
    extend Forwardable

    def_delegators :'Cagnut::Configuration.base', :jobs_dir, :prefix_name,
                   :magic28, :ref_fasta, :sample_name, :dodebug
    def_delegators :'CagnutSamtools.config', :samtools_path

    def initialize opts = {}
      @sam_dir = opts[:dirs][:input]
      @bam_dir = opts[:dirs][:output]
      @job_name = "#{prefix_name}_mgBam_#{sample_name}"
      @input = opts[:input].nil? ? "#{@bam_dir}/*.bam" : opts[:input]
      @output = "#{@bam_dir}/#{sample_name}_merged.bam"
      @output_bai = "#{@bam_dir}/#{sample_name}_merged.bai"
    end

    def run previous_job_id = nil
      puts "Submitting samtoolsMergeBam #{sample_name}"
      script_name = generate_script
      ::Cagnut::JobManage.submit  script_name, @job_name, queuing_options(previous_job_id)
      [@job_name, @output]
    end

    def queuing_options previous_job_id = nil
      {
        previous_job_id: previous_job_id,
        adjust_memory: ['h_vmem=1G'],
        tools: ['samtools', 'merge_bam']
      }
    end

    def generate_script
      script_name = 'samtools_merge_bam'
      file = File.join jobs_dir, "#{script_name}.sh"
      path = File.expand_path '../templates/merge_bam.sh', __FILE__
      template = Tilt.new path
      File.open(file, 'w') do |f|
        f.puts template.render Object.new, job_params(script_name)
      end
      File.chmod(0700, file)
      script_name
    end

    def job_params script_name
      {
        bam_dir: @bam_dir,
        samtools_path: samtools_path,
        magic28: magic28,
        jobs_dir: jobs_dir,
        input: @input,
        output: @output,
        output_bai: @output_bai,
        sam_dir: @sam_dir,
        script_name: script_name,
        run_local: ::Cagnut::JobManage.run_local
      }
    end
  end
end
