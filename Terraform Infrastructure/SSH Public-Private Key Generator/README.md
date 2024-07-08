### Overview
This file provides instructions on using Terraform to dynamically generate SSH keys and manage them as files on your local system.

```
resource "tls_private_key" "tls" {
  algorithm = "RSA"
}
resource "local_file" "tls-public" {
  filename = "id_rsa.pub"
  content  = tls_private_key.tls.public_key_openssh
}

resource "local_file" "tls-private" {
  filename = "id_rsa.pem"
  content  = tls_private_key.tls.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 id_rsa.pem"
  }
}
```

### Getting Started
1. **Define Terraform Resource**: We define a Terraform resource (`tls_private_key`) to generate an RSA private key. This resource will create a new RSA key pair each time Terraform is applied.

2. **Initialize Terraform**: Run `terraform init` to initialize Terraform and download any necessary providers or modules specified in your configuration.

3. **Apply Configuration**: Execute `terraform apply -auto-approve` to apply the Terraform configuration. This command automatically approves any prompts, making the process smoother.

4. **Outputs**: After applying the configuration, Terraform will display outputs which include a GUID and a sensitive password. These are typically used to identify or access resources created during the Terraform run.

### Saving Keys as Files
To save the generated SSH keys locally:

1. **Configure Local Files**: Use Terraform's `local_file` resource to create two files:
   - `id_rsa.pub`: Contains the generated public key in OpenSSH format.
   - `id_rsa.pem`: Contains the generated private key in PEM format.

2. **Setting Permissions**: Use the `local-exec` provisioner to execute a local command (`chmod 600 id_rsa.pem`) after creating the private key file. This command ensures that the private key file has restricted permissions (readable and writable only by the file owner), enhancing security.

### Applying Changes
1. **Reapply Terraform Configuration**: After adding the configuration to save keys as files, run `terraform init` and `terraform apply -auto-approve` again. This ensures that Terraform creates the specified files (`id_rsa.pub` and `id_rsa.pem`) in your current directory.

### Maintenance
If you accidentally delete `id_rsa.pem`:

1. **Plan Changes**: Run `terraform plan` to see what changes would be made if you were to apply the Terraform configuration again. This helps you understand the impact of the deletion.

2. **Restore Files**: Use `terraform apply -auto-approve` to restore any deleted files (`id_rsa.pem`). Terraform will recreate the file according to the defined configuration.

### Conclusion
This file provides a structured guide to using Terraform for generating and managing SSH keys, emphasizing security best practices such as restricting file permissions. It encourages customization of file names and paths to suit specific project requirements while maintaining the integrity and security of sensitive information.