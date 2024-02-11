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

