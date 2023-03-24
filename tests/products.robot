*** Settings ***
Resource                        ../resources/common.resource
Test Teardown                   Close All Excel Documents
Suite Setup                     Setup Browser
Suite Teardown                  End Suite

*** Test Cases ***
Verify Products
    [Documentation]             Read product names from excel sheet and verify that those can be found from a webshop page
    [Tags]                      excel                       products                verify
    GoTo                        ${webshop}
    VerifyText                  Find your spirit animal

    # Open existing workbook
    ${document}=                Open Excel Document         ${excel_worksheet}      products

    # Start reading values from the second row, max number needs to be provided with offset
    ${product_names}=           Read Excel Column           col_num=1               max_num=6               row_offset=1              sheet_name=Fur

    # Check that we can find all the products from the web page
    FOR                         ${item}                     IN                      @{product_names}
        VerifyText              ${item}
    END

Update Product Id
    [Documentation]             Update product id to an excel sheet and save changes
    [Tags]                      excel                       products                update
    GoTo                        ${webshop}
    VerifyText                  Find your spirit animal

    # Open existing workbook
    ${document}=                Open Excel Document         ${excel_worksheet}      products

    # Create new unique product id
    ${new_id}=                  Generate Random String      length=6                chars=[NUMBERS]

    # Get the current product id
    ${current_id}=              Read Excel Cell             row_num=2               col_num=2               sheet_name=Fur

    # Write new product id to the excel
    Write Excel Cell            row_num=2                   col_num=2               value=${new_id}         sheet_name=Fur

    # Check that new value was updated to excel
    ${updated_id}=              Read Excel Cell             row_num=2               col_num=2               sheet_name=Fur
    Should Be Equal As Strings                              ${new_id}               ${updated_id}

    # Save changes to excel and commit to git
    Save Excel Document         ${excel_worksheet}
    Close All Excel Documents
    Commit And Push             ${excel_worksheet}          ${git_branch}

Update Plannumber
    GoTo                        ${webshop}
    ${planNumber1}=             Set Variable                1337
    ${planNumber2}=             Set Variable                1223434
    ${planNumber3}=             Set Variable                1223434
    ${planNumber4}=             Set Variable                1223434

    ${document}=                Open Excel Document         ${excel_Plannumbers}    plannumbers
    Write Excel Cell            row_num=2                   col_num=1               value=${planNumber1}
    Save Excel Document         ${excel_worksheet}
    Close All Excel Documents
    Commit And Push             ${excel_worksheet}          ${git_branch}