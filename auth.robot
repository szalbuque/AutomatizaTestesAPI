*** Settings ***
Resource    common.resource

*** Test Cases ***
TC 1.1: realizar autenticação com usuário válido
    # tags permitem a execução de apenas alguns testes pela linha de comando
    [Tags]    fluxo-principal    POST
    ${response}    POST /auth    PostAuthValid.json

    Status Should Be    200
    Validate Json    ${response}    CreateTokenValid.json

TC 1.2: realizar autenticação com usuário inválido
    ${response}    POST /auth    PostAuthInvalid.json

    Validate Json    ${response}    CreateTokenInvalid.json
    