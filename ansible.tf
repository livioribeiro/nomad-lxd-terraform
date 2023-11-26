resource "null_resource" "setup_ansible" {
  provisioner "local-exec" {
    command = <<-EOT
      python -m venv .venv
      .venv/bin/pip install ansible
      .venv/bin/ansible-galaxy collection install cloud.terraform
    EOT
  }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "rm -r .venv .tmp/ansible"
  # }
}
