
# connect to mg-graph
Connect-MgGraph -Scopes Organization.Read.All


# define all license names
$skuNames = @{
    'FLOW_FREE'                             = 'Microsoft Power Automate Free'
    'SPB'                                   = 'Microsoft 365 Business Premium'
    'POWER_BI_STANDARD'                     = 'Microsoft Fabric (Free)'
    'DYN365_ENTERPRISE_SALES'               = 'Dynamics 365 Sales Enterprise Edition'
    'POWER_BI_PRO'                          = 'Power BI Pro'
    'O365_BUSINESS_ESSENTIALS'              = 'Microsoft 365 Business Basic'
    'O365_BUSINESS_PREMIUM'                 = 'Microsoft 365 Business Standard'
    'Power_Pages_vTrial_for_Makers'         = 'Power Pages vTrial for Makers'
    'POWERAPPS_VIRAL'                       = 'Microsoft Power Apps Plan 2 Trial'
    'POWERAPPS_DEV'                         = 'Microsoft Power Apps for Developer'
    'MCOEV'                                 = 'Microsoft Teams Phone Standard'
    'VISIOONLINE_PLAN1'                     = 'Visio Plan 1'
    'PBI_PREMIUM_PER_USER'                  = 'Power BI Premium Per User'
    'EXCHANGEENTERPRISE'                    = 'Exchange Online (Plan 2)'
    'CCIBOTS_PRIVPREV_VIRAL'                = 'Microsoft Copilot Studio Viral Trial'
    'POWERAPPS_PER_APP_IW'                  = 'PowerApps per app baseline access'
    'PHONESYSTEM_VIRTUALUSER'               = 'Microsoft Teams Phone Resource Account'
    'EXCHANGESTANDARD'                      = 'Exchange Online (Plan 1)'
    'SKU_Dynamics_365_for_HCM_Trial'        = 'Dynamics 365 for Talent'
    'POWERAUTOMATE_ATTENDED_RPA'            = 'Power Automate Premium'
    'Teams_Premium_(for_Departments)'       = 'Teams Premium (for Departments)' 
    'Microsoft_365_E5_(no_Teams)'           = 'Microsoft 365 E5 (no Teams)'
    'PROJECT_MADEIRA_PREVIEW_IW_SKU'        = 'Dynamics 365 Business Central for IWs'
    'PROJECTPROFESSIONAL'                   = 'Project Professional (unknown)'
    'STREAM'                                = 'Microsoft Stream Trial'
    'Microsoft_Teams_Exploratory_Dept'      = 'Microsoft Teams Exploratory'
    'INTUNE_A'                              = 'Intune A (unknown)'
    'DYN365_MARKETING_APP_ATTACH'           = 'Dynamics 365 Marketing App Attach'
    'DYN365_ENTERPRISE_P1_IW'               = 'Dynamics 365 P1 Trial for Information Workers'
    'SHAREPOINTSTORAGE'                     = 'SharePoint Storage Add-On'
    'DYN365_ENTERPRISE_FIELD_SERVICE'       = 'Dynamics 365 Field Service'
    'ENTERPRISEPACK'                        = 'Microsoft 365 E3'
    'WINDOWS_STORE'                         = 'Windows Store (internal)'
    'FLOW_BUSINESS_PROCESS'                 = 'Power Automate Business Process'
    'ATP_ENTERPRISE'                        = 'Microsoft Defender for Office 365 (Plan 2)'
    'CDS_LOG_CAPACITY'                      = 'D365 Log Capacity'
    'CDS_DB_CAPACITY'                       = 'D365 Database Capacity'
    'SharePoint_advanced_management_plan_1'             = 'SharePoint advanced management plan 1'
    'Dynamics_365_Sales_Premium_Viral_Trial'            = 'Dynamics 365 Sales Premium Viral Trial'
    'Dynamics_365_Customer_Insights_Attach_New'         = 'Dynamics 365 Customer Insights Attach'
    'Dynamics_365_Intelligent_Order_Management_vTrial'  = 'Dynamics 365 Intelligent Order Management vTrial'
}


# get all active licenses in tenancy
Get-MgSubscribedSku | Select-Object `
    @{Name='LicenseName'; Expression = { $skuNames[$_.SkuPartNumber] }},
    SkuPartNumber,
    SkuId, 
    ConsumedUnits, 
    @{Name='TotalUnits'; Expression = {$_.PrepaidUnits.Enabled}}, 
    @{Name='AvailableUnits'; Expression = {$_.PrepaidUnits.Enabled - $_.ConsumedUnits}}`
    | Sort-Object -Property ConsumedUnits -Descending `
    #| Format-Table -AutoSize`
    | Export-Csv -Path C:\Temp\365-licenses.csv -NoTypeInformation


# get all assignd licenses 
$Users = Get-MgUser -All
$Results = @()
foreach ($User in $Users) {
    $Licenses = Get-MgUserLicenseDetail -UserId $User.Id

    foreach ($License in $Licenses) {
        $Results += [PSCustomObject]@{
            Name         = $User.DisplayName
            UPN          = $User.UserPrincipalName
            ID           = $User.ID
            LicenseName   = $skuNames[$License.SkuPartNumber]
            SkuPartNumber = $License.SkuPartNumber
            SkuId        = $License.SkuId
        }
    }
}
#$Results | Format-Table -AutoSize
$Results | Export-Csv -Path C:\Temp\365-user-licenses.csv -NoTypeInformation
