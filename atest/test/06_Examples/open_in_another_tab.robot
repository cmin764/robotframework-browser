*** Settings ***
Library             OperatingSystem
Resource            imports.resource

Test Setup          Open Browser To No Page
Test Teardown       Close Browser

Force Tags          slow

*** Test Cases ***
Open PDF in another tab and download it
    [Setup]    New Browser    headless=${FALSE}    downloadsPath=${EXECDIR}
    New Context    acceptDownloads=${TRUE}
    Set Browser Timeout    30s
    New Page    ${WELCOME_URL}
    Click    text=Open pdf
    Switch Page    NEW
    ${url} =    Get Url    should end with    .pdf
    ${path} =    Download    ${url}
    ${actual_size} =    Get File Size    ${path.saveAs}
    Should Be Equal    ${actual_size}    ${32201}
    Remove File    ${path.saveAs}
    Close Page
    Get Url    should end with    welcome.html
    [Teardown]    Close Browser

Download without page fails
    New Context    acceptDownloads=${TRUE}
    Run Keyword And Expect Error
    ...    Error: Download requires an active page
    ...    Download    ${WELCOME_URL}

Download without page URL fails
    New Context    acceptDownloads=${TRUE}
    New Page
    Run Keyword And Expect Error
    ...    Error: Download requires that the page has been navigated to an url
    ...    Download    ${WELCOME_URL}

Download with no acceptDownloads fails
    New Context    acceptDownloads=${FALSE}
    New Page    ${WELCOME_URL}
    Run Keyword And Expect Error
    ...    Error: Context acceptDownloads is false
    ...    Download    ${WELCOME_URL}
    [Teardown]    Close Context

Open html in another tab
    New Page    ${WELCOME_URL}
    Click    text=Open html
    Switch Page    NEW
    Get Title    ==    Error Page
    Close Page
    Get Title    ==    Welcome Page

Download works also headless
    New Context    acceptDownloads=${TRUE}
    New Page    ${WELCOME_URL}
    ${path} =    Download    ${WELCOME_URL}
    ${actual_size} =    Get File Size    ${path}[saveAs]
    Should Be True    ${actual_size} < ${500}
    Remove File    ${path}[saveAs]
    Should Contain    ${path}[suggestedFilename]    .html
