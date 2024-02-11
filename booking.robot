*** Settings ***
Resource    common.resource

*** Test Cases ***
TC 2: obter reservas
    ${response}    GET /booking
    
    Status Should Be     200
    Validate Json    ${response}    GetBooking.json

TC 3: obter reserva por ID
    # usar um ID fixo para o primeiro teste
    # ideal é pegar um ID aleatório
    ${response}    GET /booking
    ${id}     Select Random BookingId From Json    ${response}
    ${response}    GET /booking/${id}

    Status Should Be    200
    Validate Json    ${response}    GetBookingIds.json


TC 4: substituir reserva
    # a seção de setup cria objetos que ficam visíveis por todos os objetos deste teste
    [Setup]    Wrapper POST /auth
    # realizar autenticação
    ${response}    POST /auth    PostAuthValid.json
    # pegar o token da autenticação
    ${token}    Set Variable    ${response.json()}[token]
    # pegar um ID aleatório
    ${response}    GET /booking
    ${id}     Select Random BookingId From Json    ${response}
    # atualizar o registro
    ${newResponse}    PUT /booking/${id}    PutBooking.json
    # verifica o status e o contrato
    Status Should Be    200
    Validate Json     ${newResponse}    UpdateBooking.json
    # verifica se o conteúdo foi modificado
    ${response}    GET /booking/${id}
    Status Should Be    200
    Dictionaries Should Be Equal    ${response.json()}    ${newResponse.json()}
    
