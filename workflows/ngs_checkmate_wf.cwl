cwlVersion: v1.0
class: Workflow
id: ngs_checkmate_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  input_vcf:
    type:
        type: array
        items:
            type: array
            items: File
  
  snp_bed: File
  output_basename: string[]
  ram: 
    type: ['null', int]
    default: 4000

outputs:
  match_results: {type: 'File[]', outputSource: ngs_checkmate/match_results}
  correlation_matrix: {type: 'File[]', outputSource: ngs_checkmate/correlation_matrix}

steps:
  ngs_checkmate:
    run: ../tools/ngs_checkmate_vcf.cwl
    in:
      input_vcf: input_vcf
      snp_bed: snp_bed
      output_basename: output_basename
      ram: ram
    scatter: 
        - input_vcf
        - output_basename
    scatterMethod: dotproduct
    out: [match_results, correlation_matrix]


$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:AWSInstanceType'
    value: c5.9xlarge;ebs-gp2;400
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 4