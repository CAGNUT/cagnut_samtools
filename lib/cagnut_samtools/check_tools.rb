module CagnutSamtools
  module CheckTools
    def check_tool tools_path, refs
      super if defined?(super)
      ver = check_samtools tools_path['samtools']
      check_samtools_index refs['ref_fasta'] if !ver.blank?
    end

    def check_samtools path
      check_tool_ver 'Samtools' do
        `#{path} --version 2>&1| grep samtools | cut -f2 -d ' '` if path
      end
    end

    def check_samtools_index ref_path
      puts 'Checking Samtools Reference Index Files...'
      tool = 'Samtools Index'
      file = "#{ref_path}.fai"
      command = "#{@config['tools']['samtools']} faidx #{ref_path}"
      check_ref_related file, tool, command
    end

    def check_ref_related file, tool, command
      if File.exist?(file)
        puts "\t#{tool}: Done"
      else
        puts "\t#{tool}: Not Found!"
        puts "\tPlease execute command:"
        puts "\t\t#{command}"
        @check_completed = false
      end
    end
  end
end

Cagnut::Configuration::Checks::Tools.prepend CagnutSamtools::CheckTools
