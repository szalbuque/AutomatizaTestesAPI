*** Settings ***
Resource    common.resource

*** Test Cases ***
TC 2: obter reservas
    ${response}    GET /booking
    
    Status Should Be     200
    Validate Json    ${response}    GetBooking.json