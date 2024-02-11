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
    
TC5: criar reserva
    # realizar o post usando o conteúdo do arquivo PostBooking.json
    ${response}    POST /booking    PostBooking.json
    # verificar status code
    Status Should Be    200
    # verificar contrato
    Validate Json    ${response}    CreateBooking.json
    # verificar persistência
    ${id}    Set Variable    ${response.json()}[bookingid]
    ${booking}    Set Variable    ${response.json()}[booking]
    ${response}    GET /booking/${id}
    Status Should Be    200
    Dictionaries Should Be Equal    ${booking}    ${response.json()}

TC6: editar reserva
    [Setup]   Wrapper POST /auth
    #autenticação
    #pegar id ao acaso
    ${response}    GET /booking
    ${id}     Select Random BookingId From Json     ${response}
    #pegar o corpo daquele id
    ${response}     GET /booking/${id}
    #cria corpo com DepositPaid alterado
    ${body}    Change DepositPaid    ${response}    
    #alterar com o PATCH
    PATCH /booking/${id}    ${body}
    #validar status code e contrato
    Status Should Be    200
    Validate Json   ${response}     PartialUpdateBooking.json
    #validar a persistência da alteração com GET
    ${response}     GET /booking/${id}
    Status Should Be    200
    Dictionary Should Contain Sub Dictionary    ${response.json()}    ${body}

TC7: deletar reserva
    #autenticação
    [Setup]   Wrapper POST /auth
    #pegar id ao acaso
    ${response}    GET /booking
    ${id}     Select Random BookingId From Json     ${response}
    #deletar
    ${response}     DELETE /booking/${id}
    #documentação não mostra o status code esperado
    #Status Should Be    201
    #verificar com GET
    #${response}    GET /booking/${id}    ignore404=${True}
    #Status Should Be    404
    #outra forma de verificar
    #pegar todas as reservas e checar se o id deletado está lá
    ${response}    GET /booking
    Should Not Have Value In Json    ${response.json()}    json_path=$[?@.bookingid == ${id})].bookingid