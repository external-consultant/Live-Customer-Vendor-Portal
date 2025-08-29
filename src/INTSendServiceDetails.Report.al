report 81237 "INT Send Service Details"
{
    Caption = 'Send Service Details';
    // version WebPortal

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("Enter your Details")
                {
                    Caption = 'Enter your Details';
                    field(Name; UserName)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Your Name';
                        ShowMandatory = true;
                        ToolTip = 'How we can call you';
                    }
                    field(Email; Email1)
                    {
                        ApplicationArea = All;
                        Caption = 'E mail';
                        ExtendedDatatype = EMail;
                        ShowMandatory = true;
                        ToolTip = 'Enter your valid E-mail Address on which support team will send Portal Access URL';

                        // trigger OnValidate()
                        // begin
                        //     if Email1 <> '' then //begin
                        //         Clear(SMTPMail);
                        //     //SMTPMail.CheckValidEmailAddresses(Email1);
                        //     //end;
                        // end;
                    }
                    field(ContactNo; ContactNo1)
                    {
                        ApplicationArea = All;
                        Caption = 'Contact No. (Optional)';
                        ToolTip = 'Provide your Contact Number along with Country code.';
                    }
                }
                group("Enter Dynamics 365 Business Central User Details")
                {
                    Caption = 'Enter Dynamics 365 Business Central User Details';
                    field(D365UserName; D365UserName1)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter D365 User Name';
                        ShowMandatory = true;
                        ToolTip = 'Enter the User Name that you have created as per User Manual';
                    }
                    field(WebServiceAccessKey; WebServiceAccessKey1)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Web service Access Key';
                        ShowMandatory = true;
                        ToolTip = 'Enter Web Service Access Key that you have generated from User Card as per User Manual';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        Recepients: List of [Text];
        CC: List of [Text];
        BCC: List of [Text];
    begin
        if UserName = '' then
            Error('Enter your Name first.');

        if Email1 = '' then
            Error('Enter your Email Address.');

        if D365UserName1 = '' then
            Error('Enter D365 Business Central User Name');

        if WebServiceAccessKey1 = '' then
            Error('Enter D365 Business Central Web Service Access Key');

        //Clear(SMTPMail);
        //SMTPMail.CheckValidEmailAddresses(Email1);

        // Clear(SMTPMailSetup);
        // SMTPMailSetup.Get();
        // SMTPMailSetup.TestField("User ID");

        CompanyInformation.Get();

        Recepients.Add('support@intech-systems.com');
        //SMTPMail.CreateMessage('D365 Business Central', SMTPMailSetup."User ID", Recepients, 'Customer/Vendor Portal Web service Details', '');
        EmailMessage.Create(Recepients, 'Customer/Vendor Portal Web service Details', BodyHTML_lTxt, true, CC, BCC);
        BodyHTML_lTxt += 'Contact Person Name : ' + UserName;
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += 'Contact Person Email : ' + Email1;
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += 'Contact No. : ' + ContactNo1;
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += '</BR>';

        BodyHTML_lTxt += 'Web Service User Name : ' + D365UserName1;
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += 'Web Service Access Key : ' + WebServiceAccessKey1;
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += '</BR>';
        BodyHTML_lTxt += '</BR>';

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';

        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title" colspan="5">';
        BodyHTML_lTxt += '<b><font size = "4">Web Services</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Object ID';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Object Type';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Service Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Service URL';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        Clear(INTWebServiceCreate);
        INTWebServiceCreate.Create();

        TenantWebService.Reset();
        TenantWebService.SetFilter("Object ID", '%1..%2', 70144598, 70144648);
        if TenantWebService.FindSet() then
            repeat
                textVar := Format(GetSOAPURL());
                BodyHTML_lTxt += '<tr class="item">';

                BodyHTML_lTxt += '<td>';
                BodyHTML_lTxt += Format(TenantWebService."Object ID");
                BodyHTML_lTxt += '</td>';

                BodyHTML_lTxt += '<td>';
                BodyHTML_lTxt += Format(TenantWebService."Object Type");
                BodyHTML_lTxt += '</td>';

                BodyHTML_lTxt += '<td>';
                BodyHTML_lTxt += TenantWebService."Service Name";
                BodyHTML_lTxt += '</td>';

                BodyHTML_lTxt += '<td>';
                BodyHTML_lTxt += Format(GetSOAPURL());

                BodyHTML_lTxt += '</td>';

                BodyHTML_lTxt += '</tr>';
            until TenantWebService.Next() = 0
        else
            Error('Web Service not Created yet \Kindly Contact to Intech Systems Pvt Ltd. Support.');

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInformation."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInformation.Name + '<br>';
        BodyHTML_lTxt += CompanyInformation.Address + '<br>';
        BodyHTML_lTxt += CompanyInformation."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInformation.City + ',';
        BodyHTML_lTxt += CompanyInformation."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInformation."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInformation."E-Mail" + '<br></b>';

        // IF SMTPMail.TrySend() THEN
        //     MESSAGE('Thanks for the Details. \We will contact you soon');
        Clear(Email_lCdu);
        if Email_lCdu.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            if GuiAllowed then
                Message('Thanks for the Details. \We will contact you soon');
    end;

    var
        CompanyInformation: Record "Company Information";
        // SMTPMailSetup: Record "SMTP Mail Setup";
        TenantWebService: Record "Tenant Web Service";
        INTWebServiceCreate: Codeunit "INT Web Portal -Create WebServ";
        // SMTPMail: Codeunit "SMTP Mail";
        EmailMessage: Codeunit "Email Message";
        Email_lCdu: Codeunit Email;
        D365UserName1: Code[50];
        UserName: Text[50];
        ContactNo1: Text[80];
        Email1: Text[80];
        WebServiceAccessKey1: Text[80];
        textVar: Text[250];
        BodyHTML_lTxt: Text;

    local procedure GetSOAPURL(): Text
    begin
        case TenantWebService."Object Type" of
            TenantWebService."Object Type"::Page:
                exit(GetUrl(ClientType::SOAP, CompanyName, ObjectType::Page, TenantWebService."Object ID", TenantWebService));
            TenantWebService."Object Type"::Codeunit:
                exit(GetUrl(ClientType::SOAP, CompanyName, ObjectType::Codeunit, TenantWebService."Object ID", TenantWebService));
            else
                exit('Not Applicable');
        end
    end;
}

