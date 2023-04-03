locals {
  helm_arguments = {
    atomic                = false
    cleanup_on_fail       = true
    dependency_update     = true
    force_update          = false
    recreate_pods         = false
    render_subchart_notes = true
    replace               = false
    reset_values          = false
    reuse_values          = true
    skip_crds             = false
    timeout               = 900
    verify                = false
    wait                  = true
    extra_values          = ""
  }

  helm_defaults = merge(
    local.helm_arguments,
    var.helm_defaults
  )
}
