*** Settings ***
Resource                 ../resources/common.resource
Suite Setup              Setup Browser
Suite Teardown           End Suite
Library                  String
Library                  Collections
Library                  OperatingSystem

*** Test Cases ***
Create csv and push
    ${csvFile}=         Set Variable     ${CURDIR}/../data/test.csv
    ${planNumber1}=      Set Variable                1337
    ${planNumber2}=      Set Variable                133789
    Create File          ${csvFile}
    ${header_string}=    Convert to String           Plannumbers

    # Create the header
    Append To File       ${csvFile}                  ${header_string}
    Append To File       ${csvFile}                    \n${planNumber1}
    Append To File       ${csvFile}                    \n${planNumber2}
    Commit And Push             ${csvFile}          ${git_branch}

    ${fileData}=                Get File                    ../data/test.csv
    @{read}=    Create List    ${fileData}
     @{lines}=    Split To Lines    @{read}    1
     FOR    ${line_csv}    IN    @{lines}
         Log To Console    ${line_csv}
     END
     RemoveFile            ${CURDIR}/../data/test.csv
     Commit And Push             ${EMPTY}          ${git_branch}