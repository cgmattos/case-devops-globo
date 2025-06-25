## Criar service account para o terraform

1) Acessar o Console da GCP com a conta admin e criar um novo projeto
2) Acessar o cloud shell (ou utilizar o gcloud localmente caso já tenha instalado e autenticado) e rodar o comando gcloud:
    gcloud iam service-accounts create terraform   --description="Service Account for Terraform"   --display-name="Terraform SA"
3) Rodar o comando para dar permissão à service account para editar recursos:
    gcloud projects add-iam-policy-binding [PROJECT_ID] \
  --member="serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com" \
  --role="roles/editor" \
  --role="roles/run.admin"
4) Rodar o comando para gerar o arquivo json para autenticação do provider da GCP do terraform
    gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account=terraform@[PROJECT_ID].iam.gserviceaccount.com
5) Salvar o arquivo em algum lugar e apontar as configurações do Terraform para o mesmo 