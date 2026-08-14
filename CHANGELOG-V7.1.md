# Nova Geração Manager 7.1 — fotos, chamada e documentos

## Incluído

- Foto obrigatória do atleta na inscrição.
- Botão para abrir a câmera frontal no celular/tablet e tirar a foto na hora.
- Escolha de imagem da galeria como alternativa.
- Foto exibida no elenco e na chamada.
- Atualização da foto pela ficha interna do atleta.
- Atestado médico opcional no momento da inscrição.
- Central pública `documentos.html` para envio posterior de atestado ou documento.
- Validação do envio posterior por protocolo + nascimento + últimos 4 dígitos do WhatsApp.
- Foto/PDF de documento via celular/tablet.
- Status visual do atestado na lista de atletas.
- Campo de validade do atestado.
- Upload interno de atestado pela secretaria/coordenação.
- Regras de Storage para fotos, documentos médicos e envios temporários.
- Cloud Function `submitPendingDocument` para vincular documento à inscrição e ao atleta já matriculado.
- Metadados de documentos separados de dados públicos.

## Fluxo principal

Inscrição → foto do atleta → pré-inscrição → aprovação → foto no elenco/chamada.

Se faltar documento:

Central de Documentos → protocolo → upload → validação → documento vinculado → ficha/atestado atualizado.
