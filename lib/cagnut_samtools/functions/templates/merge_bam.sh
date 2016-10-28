#!/bin/bash

cd "#{jobs_dir}/../"
echo "#{script_name} is starting at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"
rm -f #{output} #{output_bai}
CORE_LIST=$(ls core.*)
if [ -n "$CORE_LIST" ]
then
  echo "Found core dumps from bwa. Exiting with error."
  exit 100
fi

arr=$(ls #{input})
if [ ${#arr[@]} -eq 0 ]
then
  echo "Error: No BAM files found in BAM_DIR(#{bam_dir})"
  exit 100
elif [ ${#arr[@]} -eq 1 ]
then
  # bam1=$(ls #{bam_dir}/*.bam | head -1)
  cp ${arr[0]} #{output} #{run_local}
else
  # create sam header for merged bam
  # bam1=$(ls #{bam_dir}/*.bam | head -1)
  #{samtools_path} view -H ${arr[0]} | grep -v RG > #{sam_dir}/header.sam #{run_local}
  for i in `ls #{bam_dir}/*.bam`;do #{samtools_path} view -H $i | grep RG;done | sort | uniq >> #{sam_dir}/header.sam #{run_local}
  #{samtools_path} merge -h #{sam_dir}/header.sam #{output} #{bam_dir}/*.bam #{run_local}
fi

EXITSTATUS=$?

if [ ! -s "#{output}" ]
then
  echo "Incorrect Output!"
  exit 100
fi

# Check BAM EOF
BAM_28=$(tail -c 28 #{output}|xxd -p)
if [ "#{magic28}" != "$BAM_28" ]
then
  echo "Error with BAM EOF" 1>&2
  exit 100
fi

#{samtools_path} index #{output} #{run_local}
mv #{bam_dir}/#{output}.bai #{output_bai}
echo "#{script_name} is finished at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"

exit $EXITSTATUS
