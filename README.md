# Software AG Mainstream DevOps - Product and Fix Zip Images Creation

## Quick Start

- Assure the [prerequisites](https://github.com/SoftwareAG/sag-mainstream-devops-az-00-prerequisites) first.
- Use this repository as a template and create your own. Adapt the content of `azure-pipelines.yml` to match your DevOps agent pool.
- Besides the secure files, add a variable group in the pipeline library section called `ProductImageBuild.Options` with the following values
  - `MY_SUIF_TAG="v.0.5.1"` or `MY_SUIF_TAG="v.0.5.1"`
    - Adjust eventually the tag according to [SUIF](https://github.com/SoftwareAG/sag-unattended-installations) evolution
  - `SUIF_DEBUG_ON="0"`
    - Set this to 1 for troubleshooting, but attend the pipelines in this case as debugging can put the tools in user input wait mode. If you reach such a situation you might need to go inside the agent and troubleshoot. After troubleshooting, kill the agents from the Azure Portal
  - `MY_templates="MSR/1011/lean MSR/1011/AdaptersSet1"`
    - This is a space separated list of templates
    - Adapt the templates list to your required [SUIF setup templates](https://github.com/SoftwareAG/sag-unattended-installations/tree/main/02.templates/01.setup)
